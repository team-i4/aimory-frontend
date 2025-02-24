import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../../../core/util/secure_storage.dart';
import '../models/notice_model.dart';
import '../provider/notice_provider.dart';
import 'notice_insert_screen.dart';

class TeacherNoticeDetailScreen extends ConsumerWidget {
  final int noticeId; // 공지사항 ID를 받아서 API에서 불러옴

  const TeacherNoticeDetailScreen({Key? key, required this.noticeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeDetailProvider(noticeId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text(
          '공지사항',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: noticeAsync.when(
        data: (notice) => SingleChildScrollView( // ✅ 스크롤 가능하게 변경
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        notice.date ?? "날짜 없음",
                        style: const TextStyle(fontSize: 16, color: LIGHT_GREY_COLOR)),
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
                        "수정하기",
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
                const SizedBox(height: 16),
                Text(notice.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                if (notice.images != null && notice.images!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      notice.images!.first,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  )
                else
                  const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(notice.content, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("공지사항을 불러오지 못했습니다: $error")),
      ),
    );
  }
}