import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

class SwipeToDelete extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;

  const SwipeToDelete({
    Key? key,
    required this.child,
    required this.onDelete,
  }) : super(key: key);

  @override
  _SwipeToDeleteState createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<SwipeToDelete> {
  double _dragExtent = 0.0;
  double buttonWidth = 60.0; // 버튼 너비
  double initialButtonOffset = 60.0; // 버튼 초기 위치 조정 값

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 삭제 버튼 (고정된 너비)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 60.0,
          child: Transform.translate(
            offset: Offset(_dragExtent + 60, 0), // 초기 위치 조정
            child: Container(
              decoration: BoxDecoration(
                color: MID_GREY_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), // 왼쪽 위 모서리
                  bottomLeft: Radius.circular(12), // 왼쪽 아래 모서리
                  topRight: Radius.zero, // 오른쪽 위 모서리는 0
                  bottomRight: Radius.zero, // 오른쪽 아래 모서리는 0
                ),
                border: Border.all(color: Colors.grey, width: 1), // 테두리
              ),
              // color: MID_GREY_COLOR,
              child: IconButton(
                icon: Icon(Icons.delete, color: MAIN_YELLOW, size: 30),
                onPressed: () {
                  widget.onDelete(); // 삭제 콜백 호출
                  setState(() {
                    _dragExtent = 0; // 스와이프 위치 초기화
                  });
                },
              ),
            ),
          ),
        ),
        // 스와이프 가능한 영역
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragExtent += details.delta.dx;
              if (_dragExtent < -buttonWidth) _dragExtent = -buttonWidth; // 최대 스와이프 길이 제한
              if (_dragExtent > 0) _dragExtent = 0;   // 오른쪽으로 드래그 방지
            });
          },
          onHorizontalDragEnd: (_) {
            if (_dragExtent > -buttonWidth) {
              setState(() {
                _dragExtent = 0; // 드래그가 부족하면 원래 상태로 복귀
              });
            }
          },
          child: Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}