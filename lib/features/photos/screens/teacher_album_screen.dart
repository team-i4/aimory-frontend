import 'package:aimory_app/features/photos/screens/teacher_photo_list_screen.dart';
import 'package:flutter/cupertino.dart';
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
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: DARK_GREY_COLOR),
                  onPressed: () {
                    ref.refresh(photoListProvider); // ✅ 리스트 강제 갱신
                  },
                ),
                TextButton.icon(
                  onPressed: () {}, // ✅ 추후 이미지 업로드 기능 추가
                  icon: const Icon(Icons.add, color: DARK_GREY_COLOR),
                  label: const Text("사진 추가하기", style: TextStyle(color: DARK_GREY_COLOR, fontSize: 14)),
                ),
              ],
            ),
          ),
          Expanded(
            child: photoListAsync.when(
              data: (photos) {
                if (photos.isEmpty) {
                  return const Center(child: Text("📸 사진이 없습니다."));
                }

                // 📌 전체 앨범 & 원아별 앨범 만들기
                Map<int, List<PhotoModel>> albums = {};

                for (var photo in photos) {
                  albums.putIfAbsent(photo.childId, () => []).add(photo);
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemCount: albums.length + 1, // 전체 앨범 포함
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAlbumTile(context, "전체", photos.length, photos);
                    }
                    final childId = albums.keys.elementAt(index - 1);
                    final albumPhotos = albums[childId] ?? [];
                    return _buildAlbumTile(context, "원아 $childId", albumPhotos.length, albumPhotos);
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

  Widget _buildAlbumTile(BuildContext context, String name, int count, List<PhotoModel> photos) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherPhotoListScreen(
              childName: name,
              photoCount: count,
              photos: photos.map((e) => e.imageUrl).toList(),
              allPhotos: photos.map((e) => e.toJson()).toList(), // ✅ allPhotos 추가
            ),
          ),
        );
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