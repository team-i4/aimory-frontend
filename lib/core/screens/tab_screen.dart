import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/parent_info_update_screen.dart';
import '../../features/home/screens/parent_home_screen.dart';
import '../../features/home/screens/teacher_home_screen.dart';
import '../../features/notes/screens/parent_note_list_screen.dart';
import '../../features/notices/screens/parent_notice_list_screen.dart';
import '../../features/notices/screens/teacher_notice_list_screen.dart';
import '../../features/notes/screens/teacher_note_list_screen.dart';
import '../../features/photos/screens/parent_photo_list_screen.dart';
import '../../features/photos/screens/teacher_photo_list_screen.dart';
import '../../features/auth/screens/teacher_info_update_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedTabIndex = 0;

  // Teacher Body 위젯 리스트
  final List<Widget> _tabBodies = [
    const TeacherHomeScreen(), // Home Screen
    const TeacherNoticeListScreen(), // Notice Screen
    TeacherNoteListScreen(), // Note Screen
    const TeacherPhotoListScreen(), // Photo Screen
    const TeacherInfoUpdateScreen(), // Info Screen
  ];
  // // Parent Body 위젯 리스트
  // final List<Widget> _tabBodies = [
  //   const ParentHomeScreen(), // Home Screen
  //   const ParentNoticeListScreen(), // Notice Screen
  //   const ParentNoteListScreen(), // Note Screen
  //   const ParentPhotoListScreen(), // Photo Screen
  //   const ParentInfoUpdateScreen(), // Info Screen
  // ];

  // BottomNavigationBarItem label 리스트
  final List<String> _tabLabels = [
    "홈",
    "공지사항",
    "알림장",
    "사진첩",
    "내정보",
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Home 탭만 AppBar 없이 렌더링
      appBar: _selectedTabIndex == 0
          ? null
          : AppBar(
        centerTitle: true,
        title: Text(
          _tabLabels[_selectedTabIndex],
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: MAIN_YELLOW,
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _tabBodies,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedTabIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
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