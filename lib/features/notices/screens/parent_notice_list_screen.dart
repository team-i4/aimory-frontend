import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../provider/notice_provider.dart';
import 'parent_notice_detail_screen.dart';

class ParentNoticeListScreen extends ConsumerWidget {
  const ParentNoticeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeListAsync = ref.watch(noticeListProvider); // ✅ 공지사항 리스트 불러오기

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                noticeListAsync.when(
                  data: (notices) => Text("${notices.length}개", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  loading: () => const Text("로딩 중...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  error: (_, __) => const Text("오류 발생", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentNoticeDetailScreen(noticeId: notice.id!), // ✅ ID만 전달
                          ),
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