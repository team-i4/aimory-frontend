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

class TabScreen extends StatefulWidget {
  static final GlobalKey<_TabScreenState> tabScreenKey = GlobalKey<_TabScreenState>(); // GlobalKey 추가

  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; // TabController
  String? role;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadRole();
  }

  Future<void> _loadRole() async {
    final storedRole = await SecureStorage.readUserRole();
    setState(() {
      role = storedRole;
    });
  }

  void changeTab(int index) {
    if (index < 0 || index >= _tabController.length) return;
    _tabController.animateTo(index); // 탭 이동
  }


  @override
  void dispose() {
    _tabController.dispose(); // TabController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStorage.readUserRole(), // ✅ 비동기로 role 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // ✅ 로딩 UI
          );
        }

        final userRole = snapshot.data ?? "UNKNOWN"; // 기본값 UNKNOWN 처리

        // ✅ role에 따른 TabView 설정
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
          ParentPhotoListScreen(childId: 123), // 원아 ID 직접 전달
          ParentInfoScreen(),
        ]
            : [
          Scaffold(body: Center(child: Text("잘못된 접근입니다. 🚨"))),
        ]; // ✅ role이 없거나 잘못된 경우 기본 화면

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
            children: tabViews, // ✅ role에 맞는 TabView 적용
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabController.index,
            onTap: (index) => _tabController.index = index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: BLACK_COLOR,
            unselectedItemColor: LIGHT_GREY_COLOR,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "공지사항"),
              BottomNavigationBarItem(icon: Icon(Icons.note), label: "알림장"),
              BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: "사진첩"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "내정보"),
            ],
          ),
        );
      },
    );
  }
}