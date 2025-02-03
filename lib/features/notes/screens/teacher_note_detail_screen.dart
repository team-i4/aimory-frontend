import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';

class TeacherNoteDetailScreen extends ConsumerWidget {
  final int noteId; // ✅ noteId를 전달받음

  const TeacherNoteDetailScreen({Key? key, required this.noteId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteDetailAsync = ref.watch(noteDetailProvider(noteId)); // ✅ 단일 조회 Provider 호출

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text(
          '알림장',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context, false); // 뒤로가기 시 삭제되지 않음을 반환
          },
        ),
      ),
      body: noteDetailAsync.when(
        data: (note) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.date, // ✅ API에서 받은 Note 데이터의 날짜 표시
                    style: TextStyle(fontSize: 16, color: LIGHT_GREY_COLOR),
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            // ✅ 수정 기능 추가 가능
                          },
                          label: const Text(
                            "수정하기",
                            style: TextStyle(
                                color: DARK_GREY_COLOR,
                                fontSize: 14
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: MID_GREY_COLOR, // 테두리 색상
                                  width: 1, // 테두리 두께
                                )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            // ✅ 삭제 기능 추가 가능
                          },
                          label: const Text(
                            "삭제하기",
                            style: TextStyle(
                                color: DARK_GREY_COLOR,
                                fontSize: 14
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: MID_GREY_COLOR, // 테두리 색상
                                  width: 1, // 테두리 두께
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),
              Text(
                note.childName ?? "이름 없음", // ✅ API에서 받은 아이 이름 표시
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: note.image != null
                    ? Image.network(
                  note.image!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )
                    : Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                note.content, // ✅ API에서 받은 알림장 내용 표시
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()), // ✅ 로딩 상태
        error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다.")), // ✅ 에러 처리
      ),
    );
  }
}