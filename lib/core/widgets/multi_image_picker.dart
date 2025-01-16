import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePicker extends StatelessWidget {
  final Function(List<XFile>) onImagesPicked;
  final Widget Function(BuildContext, Function()) builder;

  const MultiImagePicker({
    Key? key,
    required this.onImagesPicked,
    required this.builder,
  }) : super(key: key);

  Future<void> _pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null) {
        onImagesPicked(pickedFiles);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 선택 중 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, () => _pickImages(context));
  }
}