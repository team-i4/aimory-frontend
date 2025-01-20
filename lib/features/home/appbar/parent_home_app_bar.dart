import 'package:flutter/material.dart';
import '../../../core/const/colors.dart';
import '../../auth/screens/child_info_update_screen.dart';

class ParentHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ParentHomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MAIN_YELLOW,
      elevation: 0,
      toolbarHeight: 400, // 앱바의 높이 설정
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
                      onPressed: () {}, // 알림 버튼 기능
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
            const SizedBox(height: 16),
            // 날짜, 이름, 반 정보
            Text(
              "05월26일 금요일",
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
                    Text(
                      "우리아이의",
                      style: TextStyle(

                        fontFamily: 'pretendard',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: DARK_GREY_COLOR,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "하루는 어땠을까요?",
                          style: TextStyle(
                            fontFamily: 'pretendard',
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: DARK_GREY_COLOR,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.85, // 화면 너비의 90%로 설정
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '김하은',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'pretendard',
                                        fontWeight: FontWeight.w700,
                                        color: DARK_GREY_COLOR,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '만 4세',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'pretendard',
                                        color: DARK_GREY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  '해바라기반',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pretendard',
                                    color: DARK_GREY_COLOR,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChildInfoUpdateScreen()),
                                      );
                                    }, // 자세히 보기 버튼 기능
                                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                                    label: const Text(
                                      "자세히 보기",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: BLACK_COLOR,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.1, // 화면 너비 기준으로 동적 크기 설정
                            backgroundImage: AssetImage('assets/img/girl_sample.jpg'), // 교사 이미지 경로
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(300);
}