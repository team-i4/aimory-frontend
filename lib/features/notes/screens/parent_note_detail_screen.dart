import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';

class ParentNoteDetailScreen extends ConsumerWidget {
  final int noteId; // ✅ noteId를 전달받음

  const ParentNoteDetailScreen({Key? key, required this.noteId}) : super(key: key);

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
            Navigator.pop(context);
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
                  SizedBox(width: 10.0,),
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