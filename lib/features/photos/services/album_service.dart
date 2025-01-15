import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album_model.dart';

class AlbumService {
  final String apiUrl = 'https://api.example.com/albums'; // 앨범 관련 API 엔드포인트

  // 전체 앨범 목록 조회
  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['photos'];

      // JSON 데이터를 Album 객체 리스트로 변환
      return jsonData.map((data) => Album.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  // 특정 원아의 앨범 조회
  Future<Album> fetchAlbumByChildId(int childId) async {
    final response = await http.get(Uri.parse('$apiUrl/$childId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // JSON 데이터를 Album 객체로 변환
      return Album.fromJson(jsonData);
    } else {
      throw Exception('Failed to load album for childId: $childId');
    }
  }
}