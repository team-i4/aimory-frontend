import 'package:aimory_app/features/notes/screens/parent_note_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';

class ParentNoteListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteListAsync = ref.watch(noteListProvider); // ✅ 전체 알림장 조회 API 적용

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                noteListAsync.when(
                  data: (notes) => Text(
                    '${notes.length}개', // ✅ 전체 알림장 개수 표시
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  loading: () => Text(
                    '불러오는 중...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  error: (err, stack) => Text(
                    '오류 발생',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0,),
          Expanded(
            child: noteListAsync.when(
              data: (notes) => ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  NoteModel note = notes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentNoteDetailScreen(note: note),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BORDER_GREY_COLOR, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: note.image != null
                                ? Image.network(note.image!, height: 80, width: 80, fit: BoxFit.cover)
                                : Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                          ),
                          SizedBox(width: 15.0,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.childName ?? "이름 없음",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  note.date,
                                  style: TextStyle(fontSize: 12, color: LIGHT_GREY_COLOR),
                                ),
                                Text(
                                  note.content,
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_vert, size: 16.0,),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()), // ✅ 로딩 상태
              error: (err, stack) => Center(child: Text("데이터를 불러오지 못했습니다.")), // ✅ 에러 처리
            ),
          ),
        ],
      ),
    );
  }
}