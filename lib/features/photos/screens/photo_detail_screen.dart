import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/format_date_time.dart';
import '../provider/photo_provider.dart';

class PhotoDetailScreen extends ConsumerWidget { // ✅ ConsumerWidget으로 변경 (Riverpod 사용)
  final int photoId;
  final String imageUrl;
  final String title;
  final String createdAt; // ✅ 기존 date -> createdAt으로 변경
  final String role;

  const PhotoDetailScreen({
    Key? key,
    required this.photoId,
    required this.imageUrl,
    required this.title,
    required this.createdAt, // ✅ 변경된 파라미터
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) { // ✅ ref 추가
    String formattedDate = formatDateTime(createdAt);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
            Text(createdAt, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          if (role == 'teacher') // ✅ 'teacher'일 때만 삭제 버튼 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outlined, color: BLACK_COLOR),
                  onPressed: () async {
                    final photoIds = [photoId]; // ✅ 삭제할 사진 ID 리스트
                    debugPrint("🗑️ 삭제 요청: $photoIds");

                    final result = await ref.read(photoDeleteProvider(photoIds).future); // ✅ 삭제 요청 실행

                    if (result) {
                      debugPrint("✅ 사진 삭제 성공");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ 사진이 삭제되었습니다.")),
                      );

                      // ✅ 사진 목록을 강제로 새로고침
                      ref.invalidate(photoListProvider);
                      Navigator.pop(context);
                    } else {
                      debugPrint("❌ 사진 삭제 실패");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ 사진 삭제 실패")),
                      );
                    }
                  },
                ),
                const SizedBox(width: 16.0),
              ],
            ),
        ],
      ),
    );
  }
}