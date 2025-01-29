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
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                noticeListAsync.when(
                  data: (notices) => Text("${notices.length}개", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  loading: () => const Text("로딩 중...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  error: (_, __) => const Text("오류 발생", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NoticeInsertScreen()),
                    );
                  },
                  label: const Text("공지사항 작성하기", style: TextStyle(color: DARK_GREY_COLOR, fontSize: 14)),
                  style: TextButton.styleFrom(
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
          const SizedBox(height: 20.0),
          Expanded(
            child: noticeListAsync.when(
              data: (notices) {
                if (notices.isEmpty) {
                  return const Center(child: Text("공지사항이 없습니다."));
                }
                return ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return SwipeToDelete(
                      onDelete: () async {
                        final token = await SecureStorage.readToken(); // ✅ 토큰 가져오기
                        if (token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("로그인이 필요합니다.")),
                          );
                          return;
                        }

                        try {
                          await ref.read(noticeServiceProvider).deleteNotices(
                            "Bearer $token",
                            {"data": [notice.id!]}, // Map 형태로 변환
                          );
                          ref.invalidate(noticeListProvider); // 리스트 새로고침
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
                            MaterialPageRoute(builder: (context) => TeacherNoticeDetailScreen(noticeId: notice.id!)),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: notice.images != null && notice.images!.isNotEmpty
                                    ? Image.network(notice.images!.first, height: 80, width: 80, fit: BoxFit.cover)
                                    : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notice.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    Text(notice.date ?? "날짜 없음", style: const TextStyle(fontSize: 12, color: LIGHT_GREY_COLOR)),
                                    Text(notice.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.more_vert, size: 16.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text("공지사항 로드 실패: $error")),
            ),
          ),
        ],
      ),
    );
  }
}