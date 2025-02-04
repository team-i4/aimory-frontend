import 'dart:io';

import 'package:aimory_app/features/photos/screens/teacher_photo_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/const/colors.dart';
import '../../../core/widgets/photo_picker.dart';
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
          _buildTopBar(ref),
          Expanded(
            child: photoListAsync.when(
              data: (photos) {
                if (photos.isEmpty) {
                  return const Center(child: Text("📸 사진이 없습니다."));
                }

                // 📌 원아별 사진 그룹화
                final Map<int, List<PhotoModel>> albums = {};
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
                      return _buildAlbumTile(
                        context, ref, "전체", photos.length, photos, -1, // ✅ 전체 앨범은 childId 필요 없음
                      );
                    }
                    final childId = albums.keys.elementAt(index - 1);
                    final albumPhotos = albums[childId] ?? [];
                    final childName = albumPhotos.first.childName; // ✅ 원아 이름 가져오기
                    return _buildAlbumTile(context, ref, childName, albumPhotos.length, albumPhotos, childId);
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
  Widget _buildTopBar(WidgetRef ref) {
    return Container(
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
          PhotoPicker(
            onImagePicked: (File? file) async {
              if (file != null) {
                final result = await ref.read(photoUploadProvider(file).future);
                if (result) {
                  ref.invalidate(photoListProvider); // ✅ 업로드 성공 시 새로고침
                }
              }
            },
            builder: (context, file) => TextButton.icon(
              onPressed: () {},
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
              childId: childId, // ✅ 필터링 정확도 향상을 위해 ID 전달
              photoCount: count,
              allPhotos: photos.map((e) => e.toJson()).toList(),
            ),
          ),
        );
        if (result == true) {
          ref.invalidate(photoListProvider); // ✅ 삭제 후 목록 다시 불러오기
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