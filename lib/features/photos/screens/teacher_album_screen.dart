import 'package:aimory_app/features/photos/screens/photo_insert_screen.dart';
import 'package:aimory_app/features/photos/screens/teacher_photo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../models/photo_model.dart';
import '../provider/photo_provider.dart';

class TeacherAlbumScreen extends ConsumerWidget {
  const TeacherAlbumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoListAsync = ref.watch(photoListProvider);

    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(ref, context),
          Expanded(
            child: photoListAsync.when(
              data: (photos) {
                if (photos.isEmpty) {
                  return const Center(child: Text("📸 사진이 없습니다."));
                }

                // ✅ childId 기준으로 사진 그룹화
                final Map<int, List<PhotoModel>> albums = {};
                final Map<int, String> childNames = {}; // ✅ childId에 해당하는 아이 이름 저장

                for (var photo in photos) {
                  for (int i = 0; i < photo.childIds.length; i++) {
                    int childId = photo.childIds[i];
                    String childName = photo.childNames[i];

                    albums.putIfAbsent(childId, () => []).add(photo);
                    childNames[childId] = childName; // ✅ 같은 childId라면 가장 마지막 이름 사용
                  }
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: albums.length + 1, // ✅ 전체 앨범 포함
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAlbumTile(
                        context, ref, "전체", photos.length, photos, -1, // ✅ 전체 앨범 (childId -1)
                      );
                    }

                    final childId = albums.keys.elementAt(index - 1);
                    final childName = childNames.containsKey(childId) ? childNames[childId] : "이름 없음"; // ✅ 기본값 처리
                    final List<PhotoModel> childPhotos = albums[childId] ?? [];

                    return _buildAlbumTile(
                      context, ref, childName!, childPhotos.length, childPhotos, childId,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text("사진을 불러오지 못했습니다.\n$error")),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ 상단 바 (새로고침 & 사진 추가 버튼)
  Widget _buildTopBar(WidgetRef ref, BuildContext context) {
    return Container(
      color: F4_GREY_COLOR,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh, color: DARK_GREY_COLOR),
            onPressed: () {
              ref.invalidate(photoListProvider); // ✅ 새로고침 기능만 유지
            },
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PhotoInsertScreen()),
              );

              if (result == true) {
                ref.invalidate(photoListProvider); // ✅ 사진 등록 후 최신 목록 반영
              }
            },
            icon: const Icon(Icons.add, color: DARK_GREY_COLOR),
            label: const Text("사진 추가하기", style: TextStyle(color: DARK_GREY_COLOR, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: MID_GREY_COLOR, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ 앨범 타일 위젯 (전체 & 원아별)
  Widget _buildAlbumTile(
      BuildContext context,
      WidgetRef ref,
      String name,
      int count,
      List<PhotoModel> photos,
      int childId, // ✅ 특정 원아의 ID 전달 (-1이면 전체 앨범)
      ) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherPhotoListScreen(
              childName: name,
              childId: childId,
              photoCount: count,
              allPhotos: photos.map((e) => e.toJson()).toList(),
            ),
          ),
        );
        if (result == true) {
          ref.invalidate(photoListProvider);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: photos.isNotEmpty
                    ? DecorationImage(image: NetworkImage(photos.first.imageUrl), fit: BoxFit.cover)
                    : null,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text("$name ($count)", style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
