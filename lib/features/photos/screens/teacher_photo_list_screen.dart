import 'package:aimory_app/core/const/colors.dart';
import 'package:aimory_app/features/photos/screens/photo_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/format_date_time.dart';
import '../provider/photo_provider.dart';

class TeacherPhotoListScreen extends ConsumerStatefulWidget {
  final String childName;
  final int childId;
  final int photoCount; // ✅ 추가해야 함!
  final List<Map<String, dynamic>> allPhotos;

  const TeacherPhotoListScreen({
    Key? key,
    required this.childName,
    required this.childId,
    required this.photoCount, // ✅ 추가!
    required this.allPhotos,
  }) : super(key: key);

  @override
  _TeacherPhotoListScreenState createState() => _TeacherPhotoListScreenState();
}

class _TeacherPhotoListScreenState extends ConsumerState<TeacherPhotoListScreen> {
  late List<Map<String, dynamic>> filteredPhotos;

  @override
  void initState() {
    super.initState();
    _filterPhotos();
  }

  /// ✅ 특정 원아의 사진만 필터링하는 함수
  void _filterPhotos() {
    setState(() {
      if (widget.childId == -1) {
        filteredPhotos = widget.allPhotos; // ✅ 전체 앨범
      } else {
        filteredPhotos = widget.allPhotos
            .where((photo) => photo['childId'] == widget.childId)
            .toList();
      }
    });

    debugPrint("📸 필터링된 사진 개수: ${filteredPhotos.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '사진첩',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ 총 사진 개수
            Text('${filteredPhotos.length}개',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.childName,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: filteredPhotos.length,
                itemBuilder: (context, index) {
                  final photo = filteredPhotos[index];
                  final photoUrl = photo['imageUrl'] ?? '';
                  final photoId = photo['photoId'] is int
                      ? photo['photoId']
                      : int.tryParse(photo['photoId'].toString()) ?? 0;

                  return GestureDetector(
                    onTap: () async {
                      // ✅ 삭제 후 화면 갱신을 위해 pop의 result 값을 확인
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoDetailScreen(
                            photoId: photoId,
                            imageUrl: photoUrl,
                            title: widget.childName,
                            createdAt: formatDateTime(photo['createdAt']),
                            role: 'teacher',
                          ),
                        ),
                      );

                      if (result == true) {
                        // ✅ 삭제 후 목록 업데이트
                        _filterPhotos();
                        ref.invalidate(photoListProvider); // ✅ Riverpod 데이터 갱신
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: LIGHT_GREY_COLOR,
                        image: photoUrl.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(photoUrl),
                          fit: BoxFit.cover,
                        )
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}