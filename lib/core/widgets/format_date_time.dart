/// createdAt 문자열을 DateTime으로 변환하고 직접 포맷하는 함수
String formatDateTime(String dateTimeString) {
  try {
    // 1️⃣ 문자열을 DateTime 객체로 변환
    DateTime dateTime = DateTime.parse(dateTimeString);

    // 2️⃣ 오전/오후 판별
    String period = dateTime.hour < 12 ? "오전" : "오후";

    // 3️⃣ 12시간제로 변환
    int hour = dateTime.hour % 12;
    hour = (hour == 0) ? 12 : hour; // 0시는 12시로 변환

    // 4️⃣ 최종 포맷팅
    return "${dateTime.year}.${_twoDigits(dateTime.month)}.${_twoDigits(dateTime.day)} "
        "$period $hour:${_twoDigits(dateTime.minute)}";
  } catch (e) {
    return "날짜 없음"; // 예외 처리
  }
}

/// 한 자리 숫자를 두 자리로 변환하는 함수 (ex. 1 -> 01)
String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}