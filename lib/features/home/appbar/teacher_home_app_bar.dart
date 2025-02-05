import 'package:aimory_app/features/auth/providers/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../../auth/screens/center_info_update_screen.dart';
import '../../search/screen/parent_search_screen.dart';

class TeacherHomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const TeacherHomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherInfoProvider); // 선생님 API 조회


    return AppBar(
      backgroundColor: MAIN_YELLOW,
      elevation: 0,
      toolbarHeight: 280, // 앱바의 높이 설정
      automaticallyImplyLeading: false, // 기본값인 뒤로가기 버튼 제거
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 로고 및 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 로고
                Row(
                  children: [
                    Image.asset(
                      'assets/img/aimory_horizontal_logo.png', // 로고 이미지 경로
                      height: 20,
                    ),
                  ],
                ),
                // 알림 및 설정 아이콘
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParentSearchScreen()),
                        );
                      }, // 알림 버튼 기능
                      icon: const Icon(
                        Icons.search_outlined,
                        size: 30,
                        color: DARK_GREY_COLOR,
                      ),
                    ),
                    IconButton(
                      onPressed: () {}, // 설정 버튼 기능
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                        color: DARK_GREY_COLOR,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // 날짜, 이름, 반 정보
            Text(
              "02월 07일 금요일",
              style: TextStyle(
                fontSize: 14,
                color: MAIN_DARK_GREY,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    teacherAsync.when(
                        data: (teacher) => Text(
                          "${teacher.name} 교사",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: DARK_GREY_COLOR,
                          ),
                        ),
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다."))
                    ),
                    Text(
                      "해바라기 반",
                      style: TextStyle(
                        fontSize: 20,
                        color: DARK_GREY_COLOR,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 자세히 보기 버튼
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CenterInfoUpdateScreen()),
                          );
                        }, // 자세히 보기 버튼 기능
                        icon: const Icon(Icons.add, size: 14, color: DARK_GREY_COLOR),
                        label: const Text(
                          "자세히 보기",
                          style: TextStyle(
                            color: DARK_GREY_COLOR,
                            fontSize: 12
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // 교사 이미지
                teacherAsync.when(
                    data: (teacher) => CircleAvatar(
                      radius: 50,
                      backgroundImage: teacher.profileImageUrl != null
                          ? NetworkImage(teacher.profileImageUrl!)
                          : AssetImage("assets/img/default_profile.png") as ImageProvider,
                    ),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다."))
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(260);
}