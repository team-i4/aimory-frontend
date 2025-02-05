import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/const/colors.dart';
import '../providers/search_provider.dart';

class ParentSearchScreen extends ConsumerStatefulWidget {
  @override
  _ParentSearchScreenState createState() => _ParentSearchScreenState();
}

class _ParentSearchScreenState extends ConsumerState<ParentSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String? _resultText;
  bool _isLoading = false; // ✅ 로딩 상태 추가

  void _onSearch() async {
    setState(() {
      _isLoading = true;
    });

    final response = await ref.read(searchProvider(_searchController.text).future);

    setState(() {
      _isLoading = false;
      _resultText = response.content; // ✅ 검색 결과 적용
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
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
            Navigator.pop(context, false);
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
              const SizedBox(height: 30),
              const Text(
                '우리 아이 어린이집 생활\n쉽게 검색하세요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: MID_GREY_COLOR,
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '2025년 12월 7일 지아가 먹은 식단 알려줘',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: MID_GREY_COLOR,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: MID_GREY_COLOR, // ✅ 포커스 시 테두리 색상 변경 (보라색)
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _onSearch,
                          icon: const Icon(Icons.search),
                          color: LIGHT_GREY_COLOR,
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // ✅ 로딩 상태 추가
              if (_isLoading) ...[
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
              ],

              if (_resultText != null) ...[
                const SizedBox(height: 20),
                const Text(
                  '답변',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MAIN_LIGHT_YELLOW,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _resultText!,
                    style: const TextStyle(fontSize: 16),
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