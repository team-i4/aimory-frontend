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
  final double buttonWidth = 80.0; // 삭제 버튼의 너비

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 삭제 버튼
        Positioned(
          right: -buttonWidth + _dragExtent, // 삭제 버튼이 스와이프에 따라 이동
          top: 0,
          bottom: 0,
          width: buttonWidth,
          child: Container(
            color: Colors.red, // 삭제 버튼 배경색
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: widget.onDelete, // 삭제 버튼 클릭 동작
            ),
          ),
        ),
        // 스와이프 가능한 리스트 아이템
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragExtent += details.delta.dx;
              if (_dragExtent < -buttonWidth) _dragExtent = -buttonWidth; // 최대 스와이프 길이 제한
              if (_dragExtent > 0) _dragExtent = 0; // 오른쪽으로 드래그 방지
            });
          },
          onHorizontalDragEnd: (_) {
            if (_dragExtent > -buttonWidth / 2) {
              // 스와이프가 반 이상 진행되지 않으면 복귀
              setState(() {
                _dragExtent = 0;
              });
            } else {
              // 반 이상 진행되면 삭제 버튼 위치 고정
              setState(() {
                _dragExtent = -buttonWidth;
              });
            }
          },
          child: Transform.translate(
            offset: Offset(_dragExtent, 0), // 리스트 아이템이 스와이프에 따라 이동
            child: widget.child,
          ),
        ),
      ],
    );
  }
}