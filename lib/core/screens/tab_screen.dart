import 'package:aimory_app/core/const/colors.dart';
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

  // 부모 사용자와 연관된 원아 정보를 저장(임시)
  final int parentChildId = 123;


  // BottomNavigationBarItem label 리스트
  final List<String> _tabLabels = [
    "홈",
    "공지사항",
    "알림장",
    "사진첩",
    "내정보",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this); // TabController 초기화
    // TabController 상태 변화 시 업데이트
    _tabController.addListener(() {
      setState(() {}); // 상태를 강제로 업데이트
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
    return Scaffold(
      // Home 탭만 AppBar 없이 렌더링
      appBar: _tabController.index == 0
        ? null
        : AppBar(
          centerTitle: true,
          title: Text(
            _tabLabels[_tabController.index],
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: MAIN_YELLOW,
      ),
      body: TabBarView(
        controller: _tabController, // TabController 연결
        children: [
          // TeacherHomeScreen(), // Home Screen
          // TeacherNoticeListScreen(), // Notice Screen
          // TeacherNoteListScreen(), // Note Screen
          // TeacherAlbumScreen(), // Photo Screen
          // TeacherInfoScreen(), // Info Screen

          ParentHomeScreen(),
          ParentNoticeListScreen(),
          ParentNoteListScreen(),
          ParentPhotoListScreen(childId: parentChildId), // 데이터를 직접 전달
          ParentInfoScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index, // 현재 TabController의 index와 동기화
        onTap: (index) {
          _tabController.index = index; // 탭 전환
        },
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
  }
}
