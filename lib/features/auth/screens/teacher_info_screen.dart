import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/auth/providers/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'center_info_insert_screen.dart';
import 'info_insert_screen.dart';

class TeacherInfoScreen extends ConsumerWidget {
  const TeacherInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherAsync = ref.watch(teacherInfoProvider); // 선생님 조회 API

    return Scaffold(
      backgroundColor: MAIN_LIGHT_YELLOW, // 배경색
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 사용자 정보
              teacherAsync.when(
                data: (teacher) => Column(
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: teacher.profileImageUrl != null
                          ? NetworkImage(teacher.profileImageUrl!)
                          : AssetImage("assets/img/default_profile.png") as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        teacher.name,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다."))
              ),
              const SizedBox(height: 32),

              // 버튼 섹션
              Container(

                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: MAIN_YELLOW,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const InfoInsertScreen()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.person_2_sharp, size: 25.0,),
                          SizedBox(height: 10.0,),
                          SizedBox(
                            width: 80.0, // 버튼의 고정 너비 설정
                            child: Text(
                              '나의 정보 수정', // 예시 텍스트
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              style: TextStyle(fontSize: 12, color: BLACK_COLOR,),
                              maxLines: 2, // 최대 줄 수 설정
                              overflow: TextOverflow.visible, // 줄이 넘치면 자동 줄바꿈
                              softWrap: true, // 줄바꿈 활성화
                            ),
                          ),
                        ],
                      ),
                    ),


                    Container(
                      width: 0.5,
                      height: 50.0,
                      color: MID_GREY_COLOR,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CenterInfoInsertScreen()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.info_outline_sharp, size: 25.0,),
                          SizedBox(height: 10.0,),
                          SizedBox(
                            width: 80.0, // 버튼의 고정 너비 설정
                            child: Text(
                              '소속 정보 등록', // 예시 텍스트
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              style: TextStyle(fontSize: 12, color: BLACK_COLOR,),
                              maxLines: 2, // 최대 줄 수 설정
                              overflow: TextOverflow.visible, // 줄이 넘치면 자동 줄바꿈
                              softWrap: true, // 줄바꿈 활성화 // 줄바꿈 활성화
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 0.5,
                      height: 50.0,
                      color: MID_GREY_COLOR,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.call_sharp, size: 25.0,),
                          SizedBox(height: 10.0,),
                          SizedBox(
                            width: 80.0, // 버튼의 고정 너비 설정
                            child: Text(
                              '고객센터', // 예시 텍스트
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              style: TextStyle(fontSize: 12, color: BLACK_COLOR,),
                              maxLines: 2, // 최대 줄 수 설정
                              overflow: TextOverflow.visible, // 줄이 넘치면 자동 줄바꿈
                              softWrap: true, // 줄바꿈 활성화
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 30.0,),

              // 사용자 정보 섹션
              teacherAsync.when(
                  data: (teacher) => Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "이름  ${teacher.name}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "이메일  ${teacher.email}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다."))
              ),
              const SizedBox(height: 32),

              // 우리아이 정보
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "나의 소속 정보",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // 리스트 뷰
              ListView.builder(
                shrinkWrap: true, // 부모의 크기를 넘어가지 않도록 설정
                physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화 (부모 스크롤 사용)
                itemCount: 2, // 아이템 개수 (테스트용 2개)
                itemBuilder: (context, index) {
                  return _CenterInfoCard(
                    centerName: "햇님 어린이집",
                    className: "해바라기반",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 아이 정보 카드 위젯
class _CenterInfoCard extends StatelessWidget {
  final String centerName;
  final String className;

  const _CenterInfoCard({
    required this.centerName,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MAIN_YELLOW,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              centerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              className,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}