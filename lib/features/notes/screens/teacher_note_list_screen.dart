import 'package:aimory_app/features/notes/screens/note_insert_screen.dart';
import 'package:aimory_app/features/notes/screens/teacher_note_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../../../core/widgets/swipe_to_delete.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';

class TeacherNoteListScreen extends ConsumerWidget {

  /// ✅ 알림장 삭제 확인 다이얼로그
  Future<bool?> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("알림장 삭제", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("해당 알림장을 삭제하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: DARK_GREY_COLOR,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("삭제", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteListAsync = ref.watch(noteListProvider); // ✅ 알림장 전체 조회 API 호출

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                noteListAsync.when(
                  data: (notes) => Text(
                    '${notes.length}개', // ✅ API에서 가져온 알림장 개수 표시
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NoteInsertScreen()),
                      );
                      if (result == true) {
                        ref.invalidate(noteListProvider); // ✅ 알림장 추가 후 목록 갱신
                      }
                    }, // 알림장 추가 버튼 기능
                    label: const Text(
                      "알림장 작성하기",
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
          ),
          const SizedBox(height: 20.0,),
          Expanded(
            child: noteListAsync.when(
              data: (notes) => ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  NoteModel note = notes[index];
                  return SwipeToDelete(
                    onDelete: () async {
                      final confirm = await _showDeleteConfirmDialog(context);
                      if (confirm != true) return;

                      try {
                        await ref.read(noteDeleteProvider(note.id!).future);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("알림장이 삭제되었습니다.")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("삭제 실패: $e")),
                        );
                      }
                    },
                    child: GestureDetector(
                      onTap: () async {
                        bool? isUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherNoteDetailScreen(noteId: note.id ?? 0),
                          ),
                        );
                        if (isUpdated == true) {
                          ref.invalidate(noteListProvider); // ✅ 수정 후 목록 갱신
                        }
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
                            // ✅ 이미지 표시
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
                          ],
                        ),
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