import 'package:aimory_app/core/const/colors.dart';
import 'package:flutter/material.dart';

class CustomInputDecoration {
  /// 기본 스타일의 InputDecoration을 반환하는 메서드
  static InputDecoration basic({
    required String hintText, // 필드 안에 힌트 텍스트로 표시될 문자열// 텍스트 필드의 테두리 반경 (둥근 모서리 설정)
  }) {
    return InputDecoration(
      hintText: hintText, // 입력 필드 안에 표시되는 힌트 텍스트
      filled: true, // 텍스트 필드에 배경색을 활성화
      fillColor: F4_GREY_COLOR, // 활성화된 배경색의 색상
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // 테두리의 둥근 정도 설정
        borderSide: BorderSide.none, // 테두리를 제거
      ),
    );
  }

  /// 테두리를 포함한 InputDecoration을 반환하는 메서드
  static InputDecoration withBorder({
    required String hintText, // 필드 안에 힌트 텍스트로 표시될 문자열
    Color fillColor = Colors.white, // 텍스트 필드의 배경색
    Color borderColor = Colors.grey, // 테두리의 색상
    double borderRadius = 8.0, // 텍스트 필드의 테두리 반경 (둥근 모서리 설정)
    double borderWidth = 1.0, // 테두리의 두께
  }) {
    return InputDecoration(
      hintText: hintText, // 입력 필드 안에 표시되는 힌트 텍스트
      filled: true, // 텍스트 필드에 배경색을 활성화
      fillColor: fillColor, // 활성화된 배경색의 색상
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius), // 테두리의 둥근 정도 설정
        borderSide: BorderSide(
          color: borderColor, // 테두리의 색상
          width: borderWidth, // 테두리의 두께
        ),
      ),
    );
  }
}