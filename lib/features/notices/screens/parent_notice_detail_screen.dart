import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../models/notice_model.dart';
import '../provider/notice_provider.dart';

class ParentNoticeDetailScreen extends ConsumerWidget {
  final int noticeId; // 공지사항 ID를 기반으로 데이터 가져오기

  const ParentNoticeDetailScreen({Key? key, required this.noticeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeDetailProvider(noticeId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text(
          '공지사항',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: noticeAsync.when(
        data: (notice) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notice.date ?? "날짜 없음", style: const TextStyle(fontSize: 16, color: LIGHT_GREY_COLOR)),

                ],
              ),
              const SizedBox(height: 16),
              Text(notice.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              notice.images != null && notice.images!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  notice.images!.first,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              )
                  : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(notice.content, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("공지사항을 불러오지 못했습니다: $error")),
      ),
    );
  }
}