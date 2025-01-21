import 'package:flutter/material.dart';

import '../../../core/const/colors.dart';

class ParentSearchScreen extends StatefulWidget {

  @override
  _ParentSearchScreenState createState() => _ParentSearchScreenState();
}

class _ParentSearchScreenState extends State<ParentSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  // String? _resultText = '지아는 12월 7일에 돈가스를 맛있게 먹었습니다.';
  String? _resultText;

  void _onSearch() {
    setState(() {
      _resultText = "${_searchController.text}에 대한 정보를 찾았습니다!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text(
          'AI 검색',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context, false); // 뒤로가기 시 삭제되지 않음을 반환
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: MAIN_YELLOW,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 030),
              Text(
                '우리 아이 어린이집 생활\n쉽게 검색하세요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '12월 7일 지아가 먹은 식단 알려줘',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LIGHT_GREY_COLOR, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _onSearch,
                          icon: Icon(Icons.search),
                          color: LIGHT_GREY_COLOR,
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                ],
              ),
              if (_resultText != null) ...[
                SizedBox(height: 20),
                Text(
                  '답변',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MAIN_LIGHT_YELLOW,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _resultText!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),

    );
  }
}