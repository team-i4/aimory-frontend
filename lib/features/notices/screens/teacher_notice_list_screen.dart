import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../../../core/util/secure_storage.dart';
import '../../../core/widgets/swipe_to_delete.dart';
import '../models/notice_model.dart';
import '../provider/notice_provider.dart';
import 'teacher_notice_detail_screen.dart';
import 'notice_insert_screen.dart';

class TeacherNoticeListScreen extends ConsumerWidget {
  const TeacherNoticeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeListAsync = ref.watch(noticeListProvider);

    return Scaffold(
      body: Column(
        children: [
          // ✅ 상단 공지사항 개수 및 작성 버튼
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                noticeListAsync.when(
                  data: (notices) => Text(
                    "${notices.length}개",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  loading: () => const Text(
                    "로딩 중...",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  error: (_, __) => const Text(
                    "오류 발생",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    String? token = await SecureStorage.readToken();
                    if (token == null || token.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("🚨 로그인이 필요합니다.")),
                      );
                      return;
                    }

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NoticeInsertScreen()),
                    );

                    if (result == true) {
                      ref.invalidate(noticeListProvider); // ✅ 공지사항 목록 새로고침
                    }
                  },
                  icon: const Icon(Icons.add, color: DARK_GREY_COLOR),
                  label: const Text(
                    "공지사항 작성하기",
                    style: TextStyle(color: DARK_GREY_COLOR, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: MID_GREY_COLOR, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10.0),

          // ✅ 공지사항 목록
          Expanded(
            child: noticeListAsync.when(
              data: (notices) {
                if (notices.isEmpty) {
                  return const Center(child: Text("📢 공지사항이 없습니다."));
                }

                return ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return SwipeToDelete(

                      onDelete: () async {
                        String? token = await SecureStorage.readToken();
                        if (token == null || token.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("🚨 로그인이 필요합니다.")),
                          );
                          return;
                        }

                        bool? confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.white,
                            title: const Text("공지사항 삭제", style: TextStyle(color: DARK_GREY_COLOR)),
                            content: const Text("정말로 삭제하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("취소", style: TextStyle(color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DARK_GREY_COLOR,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("삭제", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete != true) return;

                        try {
                          debugPrint("🛠 DELETE 요청 데이터: ${jsonEncode({"data": [notice.id!]})}");
                          await ref.read(noticeServiceProvider).deleteNotices(
                            "Bearer $token",
                            {"data": [notice.id!]}, // 요청 형식
                          );
                          ref.invalidate(noticeListProvider); // 리스트 새로고침
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("공지사항이 삭제되었습니다.")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("삭제 실패: $e")),
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherNoticeDetailScreen(noticeId: notice.id!),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: notice.images != null && notice.images!.isNotEmpty
                                    ? Image.network(
                                  notice.images!.first,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                )
                                    : const Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notice.title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      notice.date ?? "날짜 없음",
                                      style: const TextStyle(fontSize: 12, color: LIGHT_GREY_COLOR),
                                    ),
                                    Text(
                                      notice.content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 20.0, color: MID_GREY_COLOR),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "공지사항을 불러오지 못했습니다.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "오류: $error",
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(noticeListProvider),
                      child: const Text("다시 시도"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}