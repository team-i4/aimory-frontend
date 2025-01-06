import 'package:flutter/material.dart';

import '../../features/auth/appbar/info_app_bar.dart';
import '../../features/auth/screens/teacher_info_update_screen.dart';
import '../../features/home/appbar/teacher_home_app_bar.dart';
import '../../features/home/screens/teacher_home_screen.dart';
import '../../features/notes/appbar/note_app_bar.dart';
import '../../features/notes/screens/teacher_note_list_screen.dart';
import '../../features/notices/appbar/notice_app_bar.dart';
import '../../features/notices/screens/teacher_notice_list_screen.dart';
import '../../features/photos/appbar/photo_app_bar.dart';
import '../../features/photos/screens/teacher_photo_list_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedTabIndex = 0;

  // Teacher AppBar 위젯 리스트
  final List<PreferredSizeWidget> _appBars = [
    const TeacherHomeAppBar(),
    const NoticeAppBar(),
    const NoteAppBar(),
    const PhotoAppBar(),
    const InfoAppBar(),
  ];

  // Teacher Body 위젯 리스트
  final List<Widget> _tabBodies = [
    const TeacherHomeScreen(),
    const TeacherNoticeListScreen(),
    const TeacherNoteListScreen(),
    const TeacherPhotoListScreen(),
    const TeacherInfoUpdateScreen(),
  ];

  // // Parent AppBar 위젯 리스트
  // final List<PreferredSizeWidget> _appBars = [
  //   const ParentHomeAppBar(),
  //   const NoticeAppBar(),
  //   const NoteAppBar(),
  //   const PhotoAppBar(),
  //   const InfoAppBar(),
  // ];
  //
  // // Parent Body 위젯 리스트
  // final List<Widget> _tabBodies = [
  //   const ParentHomeScreen(),
  //   const ParentNoticeListScreen(),
  //   const ParentNoteListScreen(),
  //   const ParentPhotoListScreen(),
  //   const ParentInfoUpdateScreen(),
  // ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedTabIndex], // 선택된 탭의 AppBar
      body: IndexedStack(
        index: _selectedTabIndex,
        children: _tabBodies,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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