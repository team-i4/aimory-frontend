import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/notices/provider/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/screens/tab_screen.dart';
import '../../../core/widgets/format_date_time.dart';
import '../../notices/screens/teacher_notice_detail_screen.dart';
import '../../photos/provider/photo_provider.dart';
import '../../photos/screens/photo_detail_screen.dart';
import '../appbar/teacher_home_app_bar.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeListAsync = ref.watch(noticeListProvider); // ✅ 공지사항 목록 Provider 호출

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ TeacherHomeAppBar 포함
                  const TeacherHomeAppBar(),

                  // ✅ 공지사항 리스트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ 전체 공지사항 제목
                            Text(
                              "공지사항",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(1); // "공지사항" 탭으로 이동
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "더보기",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MAIN_DARK_GREY,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: MAIN_DARK_GREY,
                                  ),
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
                                              TeacherNoticeDetailScreen(noticeId: notice.id ?? 0),
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

                          loading: () => Center(child: CircularProgressIndicator()), // ✅ 로딩 상태
                          error: (err, stack) => Center(child: Text("공지사항을 불러올 수 없습니다. 🚨")), // ✅ 에러 처리
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // ✅ 메인화면 광고 배너 부분
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/banner_sample.png',
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 40.0,),

                  // ✅ 우리반 앨범 UI 유지
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "우리반 앨범",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                TabScreen.tabScreenKey.currentState?.changeTab(3);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "더보기",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MAIN_DARK_GREY,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: MAIN_DARK_GREY,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // ✅ 우리반 앨범 GridView (API 연동)
                        Consumer(
                          builder: (context, ref, child) {
                            final photoListAsync = ref.watch(photoListProvider);

                            return photoListAsync.when(
                              data: (photos) {
                                if (photos.isEmpty) {
                                  return const Center(child: Text("📸 우리반 사진이 없습니다."));
                                }

                                // ✅ 최신 9개만 가져오기
                                final latestPhotos = photos.length > 9 ? photos.take(9).toList() : photos;

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: latestPhotos.length, // ✅ API 데이터 개수 반영
                                  itemBuilder: (context, index) {
                                    final photo = latestPhotos[index]; // ✅ 현재 사진 객체 가져오기

                                    return GestureDetector(
                                      onTap: () {
                                        // ✅ PhotoDetailScreen으로 이동
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PhotoDetailScreen(
                                              photoId: photo.photoId, // ✅ 사진 ID
                                              imageUrl: photo.imageUrl, // ✅ 이미지 URL
                                              title: photo.childNames.isNotEmpty ? photo.childNames.first : "이름 없음", // ✅ 아이 이름을 제목으로 설정
                                              createdAt: formatDateTime(photo.createdAt), // ✅ 날짜 변환 후 전달
                                              role: 'teacher', // ✅ 교사용 역할 설정
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: LIGHT_GREY_COLOR,
                                          image: DecorationImage(
                                            image: NetworkImage(photo.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator()), // ✅ 로딩 중
                              error: (err, _) => Center(child: Text("❌ 사진을 불러올 수 없습니다.")), // ✅ 에러 처리
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}