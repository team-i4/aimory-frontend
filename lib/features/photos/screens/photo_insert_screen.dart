import 'dart:io';
import 'package:aimory_app/core/widgets/custom_yellow_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/multi_image_picker.dart';
import '../../../core/util/secure_storage.dart';
import '../provider/photo_provider.dart';
import '../services/photo_service.dart';

class PhotoInsertScreen extends ConsumerStatefulWidget {
  const PhotoInsertScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PhotoInsertScreen> createState() => _PhotoInsertScreenState();
}

class _PhotoInsertScreenState extends ConsumerState<PhotoInsertScreen> {
  List<File> _selectedImages = [];

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _uploadPhotos() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("사진을 선택해주세요.")));
      return;
    }

    bool? isConfirmed = await _showConfirmDialog();
    if (isConfirmed != true) return;

    final result = await ref.read(photoUploadProvider(_selectedImages).future);

    if (result) {
      ref.invalidate(photoListProvider); // ✅ 업로드 성공 후 최신화
      await _showSuccessDialog();
      Navigator.pop(context, true); // ✅ true 반환하여 새로고침 트리거
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("사진 등록 실패. 다시 시도해주세요.")));
    }
  }

  Future<bool?> _showConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("사진 등록", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("사진을 등록하시겠습니까?", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: DARK_GREY_COLOR),
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Text("사진 등록 완료", style: TextStyle(color: DARK_GREY_COLOR)),
          content: const Text("사진이 성공적으로 등록되었습니다.", style: TextStyle(color: DARK_GREY_COLOR)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: DARK_GREY_COLOR),
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("사진 추가", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MultiImagePicker(
                    onImagesPicked: (pickedFiles) {
                      setState(() {
                        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
                      });
                    },
                    builder: (context, pickImages) => CustomYellowButton(text: '사진추가', onPressed: pickImages),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedImages.asMap().entries.map((entry) {
                  int index = entry.key;
                  File image = entry.value;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: MAIN_YELLOW,
                            child: Icon(Icons.close, color: MAIN_DARK_GREY, size: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),

            CustomButton(
              text: "등록하기",
              onPressed: _uploadPhotos,
            ),
          ],
        ),
      ),
    );
  }
}
