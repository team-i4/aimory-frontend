import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input_decoration.dart';

class ChildrenInsertScreen extends ConsumerStatefulWidget {
  const ChildrenInsertScreen({super.key});

  @override
  _ChildrenInsertScreenState createState() => _ChildrenInsertScreenState();
}

class _ChildrenInsertScreenState extends ConsumerState<ChildrenInsertScreen> {
  List<String> childrenList = ["박채은", "김민수", "이서연", "정하늘", "한지민","박채은", "김민수", "이서연", "정하늘", "한지민","박채은", "김민수", "이서연", "정하늘", "한지민"]; // 예제 데이터

  // 아이템 삭제 함수
  void _deleteItem(int index) {
    setState(() {
      childrenList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_YELLOW,
        centerTitle: true,
        title: const Text("원아 등록", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('원아 이름'),
              const SizedBox(height: 8),
              TextFormField(
                decoration: CustomInputDecoration.basic(
                  hintText: '원아 이름을 입력하세요.',
                ),
              ),
              const SizedBox(height: 16),

              // 리스트 아이템 생성 (스크롤 가능)
              Expanded(
                child: ListView.builder(
                  itemCount: childrenList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint("아이템 클릭: ${childrenList[index]}");
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0), // 아이템 간 간격 추가
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12), // 둥근 테두리
                          border: Border.all(color: BORDER_GREY_COLOR, width: 1), // 개별 테두리
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 아이 이름
                            Text(
                              childrenList[index],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            // X 삭제 버튼
                            IconButton(
                              icon: Icon(Icons.close, color: MAIN_DARK_GREY),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: '등록하기',
                onPressed: () {
                  //TODO: 등록하기 이벤트 리스너
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}