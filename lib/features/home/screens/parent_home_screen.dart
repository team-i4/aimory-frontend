import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/notes/provider/note_provider.dart';
import 'package:aimory_app/features/notices/provider/notice_provider.dart';
import 'package:aimory_app/features/notes/screens/parent_note_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/screens/tab_screen.dart';
import '../../notices/screens/parent_notice_detail_screen.dart';
import '../appbar/parent_home_app_bar.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeListAsync = ref.watch(noticeListProvider); // ✅ 공지사항 목록 Provider 호출
    final noteListAsync = ref.watch(noteListProvider); // ✅ 알림장 목록 Provider 호출

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ✅ 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ ParentHomeAppBar 포함
                  const ParentHomeAppBar(),

                  // ✅ 공지사항 리스트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "공지사항",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(1);
                              },
                              child: Row(
                                children: [
                                  Text("더보기",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MAIN_DARK_GREY),
                                  ),
                                  Icon(Icons.chevron_right, size: 20, color: MAIN_DARK_GREY),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ✅ 공지사항 API 연동
                        noticeListAsync.when(
                          data: (notices) {
                            // ✅ 최신 3개만 가져오도록 리스트 제한
                            final latestNotices = notices.length > 3 ? notices.take(3).toList() : notices;

                            return Container(

                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: latestNotices.length, // ✅ API에서 가져온 데이터 개수
                                itemBuilder: (context, index) {
                                  final notice = latestNotices[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ParentNoticeDetailScreen(noticeId: notice.id ?? 0),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white, // 배경색
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(notice.title),
                                            subtitle: Text(notice.title),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                                            height: 1,
                                            color: BORDER_GREY_COLOR,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text("공지사항을 불러올 수 없습니다. 🚨")),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // ✅ 메인화면 광고 배너
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/banner_sample.png',
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 40.0,),

                  // ✅ 우리아이 알림장 리스트 (가로 스크롤)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "우리아이 알림장",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(2);
                              },
                              child: Row(
                                children: [
                                  Text("더보기",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MAIN_DARK_GREY),
                                  ),
                                  Icon(Icons.chevron_right, size: 20, color: MAIN_DARK_GREY),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        // ✅ 알림장 API 연동
                        noteListAsync.when(
                          data: (notes) => SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final note = notes[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ParentNoteDetailScreen(noteId: note.id ?? 0),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundImage: NetworkImage(note.image ?? ""),
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(note.childName ?? "이름 없음",
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                    ),
                                                    Text(note.date,
                                                      style: TextStyle(fontSize: 14, color: MAIN_DARK_GREY),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Divider(),
                                            const SizedBox(height: 8),
                                            Text(
                                              note.content,
                                              style: TextStyle(fontSize: 14),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          loading: () => Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text("알림장을 불러올 수 없습니다. 🚨")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}