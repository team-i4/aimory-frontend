import 'package:aimory_app/features/photos/screens/teacher_photo_list_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/const/colors.dart';
import '../models/album_model.dart';
import '../services/album_service.dart';

class TeacherAlbumScreen extends StatefulWidget {
  const TeacherAlbumScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAlbumScreen> createState() => _TeacherAlbumScreenState();
}

class _TeacherAlbumScreenState extends State<TeacherAlbumScreen> {
  late Future<List<Album>> albums;

  @override
  void initState() {
    super.initState();
    // albums = AlbumService().fetchAlbums(); // 앨범 목록 가져오기
    albums = _fetchAlbumsMock(); // 임시 데이터 사용
  }

  // 임시 데이터를 반환하는 함수
  Future<List<Album>> _fetchAlbumsMock() async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 효과를 위해 딜레이 추가
    return [
      Album(
        childId: 1,
        name: '이채은',
        profileImageUrl: 'https://imgnews.pstatic.net/image/366/2025/01/15/0001047437_001_20250115110120234.jpg', // 샘플 이미지 URL
        count: 12,
      ),
      Album(
        childId: 2,
        name: '송유리',
        profileImageUrl: 'https://imgnews.pstatic.net/image/366/2025/01/15/0001047437_002_20250115110121752.jpg', // 샘플 이미지 URL
        count: 8,
      ),
      Album(
        childId: 3,
        name: '권재아',
        profileImageUrl: 'https://imgnews.pstatic.net/image/366/2025/01/15/0001047437_002_20250115110121752.jpg', // 샘플 이미지 URL
        count: 15,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: F4_GREY_COLOR,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 버튼을 오른쪽 정렬
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const PhotoInsertScreen()),
                    // );
                  }, // 사진 추가 버튼 기능
                  label: const Text(
                    "사진 추가하기",
                    style: TextStyle(
                      color: DARK_GREY_COLOR,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: MID_GREY_COLOR, // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                    ),
                  ),
                  icon: Icon(Icons.add, color: DARK_GREY_COLOR), // 아이콘 추가
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Album>>(
              future: albums,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                }

                final albumList = snapshot.data ?? [];

                // 맨 앞의 전체 앨범
                final allAlbums = [
                  Album(
                    childId: 0, // "전체 앨범"의 childId는 0으로 설정
                    name: '전체',
                    profileImageUrl: 'https://imgnews.pstatic.net/image/366/2025/01/15/0001047437_002_20250115110121752.jpg', // 샘플 이미지 URL
                    count: albumList.fold(0, (sum, album) => sum + album.count), // 모든 사진의 합
                  ),
                  ...albumList, // 원래의 앨범 리스트
                ];

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 줄에 두 개의 아이템
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1, // 정사각형 비율
                  ),
                  itemCount: allAlbums.length,
                  itemBuilder: (context, index) {
                    final album = allAlbums[index];
                    return GestureDetector(
                      onTap: () {
                        // "전체 앨범" 또는 개별 앨범 클릭 시 처리
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherPhotoListScreen(
                              childName: album.name,
                              photoCount: album.count,
                              photos: List.generate(
                                album.count,
                                    (idx) => 'https://imgnews.pstatic.net/image/366/2025/01/15/0001047437_002_20250115110121752.jpg',
                              ),
                              allPhotos: []
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // 기본 배경색
                                image: DecorationImage(
                                  image: NetworkImage(album.profileImageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${album.name}(${album.count})',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}