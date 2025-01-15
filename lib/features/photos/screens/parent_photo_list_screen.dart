import 'package:aimory_app/features/photos/screens/photo_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:aimory_app/core/const/colors.dart';

import '../models/album_model.dart';
import '../services/album_service.dart';

class ParentPhotoListScreen extends StatefulWidget {
  final int childId;

  const ParentPhotoListScreen({
    Key? key,
    required this.childId,
  }) : super(key: key);

  @override
  State<ParentPhotoListScreen> createState() => _ParentPhotoListScreenState();
}

class _ParentPhotoListScreenState extends State<ParentPhotoListScreen> {
  late Future<Album> album;

  @override
  void initState() {
    super.initState();
    // album = AlbumService().fetchAlbumByChildId(widget.childId);
    album = _fetchAlbumMock();
  }

  // 임시 데이터를 반환하는 함수
  Future<Album> _fetchAlbumMock() async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 효과를 위해 딜레이 추가
    return Album(
      childId: widget.childId,
      name: '이채은',
      profileImageUrl: 'https://imgnews.pstatic.net/image/056/2025/01/15/0011875678_001_20250115182816671.jpg', // 샘플 이미지 URL
      count: 9, // 사진 개수
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Album>(
        future: album,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          // 임시 사진 URL 리스트 생성
          final List<String> photos = List.generate(
            data.count,
                (index) =>
            'https://imgnews.pstatic.net/image/056/2025/01/15/0011875678_001_20250115182816671.jpg',
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 정보 (사진 개수, 원아 이름)
                Text(
                  '${data.count}개',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // 사진 GridView
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 한 줄에 세 개의 사진
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: data.count,
                    itemBuilder: (context, index) {

                      final photoUrl = photos[index];
                      return GestureDetector(
                        onTap: () {
                          // PhotoDetailScreen으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoDetailScreen(
                                imageUrl: photoUrl,
                                title: data.name,
                                date: '2024.05.26. 오후 3:00', // 예제 날짜
                                role: 'parent', // 부모 역할
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: LIGHT_GREY_COLOR, // 기본 배경색
                            image: DecorationImage(
                              image: NetworkImage(photoUrl), // 네트워크 이미지 표시
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}