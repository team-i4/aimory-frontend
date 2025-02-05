import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/core/util/secure_storage.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/parent_info_screen.dart';
import '../../features/home/screens/parent_home_screen.dart';
import '../../features/home/screens/teacher_home_screen.dart';
import '../../features/notes/screens/parent_note_list_screen.dart';
import '../../features/notices/screens/parent_notice_list_screen.dart';
import '../../features/notices/screens/teacher_notice_list_screen.dart';
import '../../features/notes/screens/teacher_note_list_screen.dart';
import '../../features/photos/screens/parent_photo_list_screen.dart';
import '../../features/photos/screens/teacher_album_screen.dart';
import '../../features/auth/screens/teacher_info_screen.dart';
import 'dart:developer' as dev;

class TabScreen extends StatefulWidget {
  static final GlobalKey<_TabScreenState> tabScreenKey = GlobalKey<_TabScreenState>();

  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<String?>? _userRoleFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // 한 번만 실행하고 저장
    _userRoleFuture = SecureStorage.readUserRole();

    // 탭 변경 시 setState()를 호출하도록 리스너 추가
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});  // 탭이 변경될 때 UI 업데이트
      }
    });
  }

  void changeTab(int index) {
    if (index < 0 || index >= _tabController.length) return;
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userRoleFuture, // ✅ 비동기로 role 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // ✅ 로딩 UI
          );
        }

        final userRole = snapshot.data ?? "UNKNOWN"; // 기본값 UNKNOWN 처리
        debugPrint("현재 사용자 role: $userRole");


        final List<Widget> tabViews = userRole == "TEACHER"
            ? [
          TeacherHomeScreen(),
          TeacherNoticeListScreen(),
          TeacherNoteListScreen(),
          TeacherAlbumScreen(),
          TeacherInfoScreen(),
        ]
            : userRole == "PARENT"
            ? [
          ParentHomeScreen(),
          ParentNoticeListScreen(),
          ParentNoteListScreen(),
          ParentPhotoListScreen(childId: 123),
          ParentInfoScreen(),
        ]
            : [
          Scaffold(body: Center(child: Text("잘못된 접근입니다. 🚨"))),
        ];

        return Scaffold(
          appBar: _tabController.index == 0
              ? null
              : AppBar(
                  centerTitle: true,
                  title: Text(
                    ["홈", "공지사항", "알림장", "사진첩", "내정보"][_tabController.index],
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: MAIN_YELLOW,
                ),
          body: TabBarView(
            controller: _tabController,
            children: tabViews,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabController.index,
            onTap: (index) => _tabController.animateTo(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: BLACK_COLOR,
            unselectedItemColor: LIGHT_GREY_COLOR,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈"),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "공지사항"),
              BottomNavigationBarItem(icon: Icon(Icons.note_outlined), label: "알림장"),
              BottomNavigationBarItem(icon: Icon(Icons.photo_album_outlined), label: "사진첩"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: "내정보"),
            ],
          ),
        );
      },
    );
  }
}