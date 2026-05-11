// 금액 콤마 포맷팅 헬퍼 함수
import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},'
  );
}

String formatCurrentDate() {
  DateTime now = DateTime.now();

  // 2. 원하는 포맷 설정 (yyyyMMdd HH:mm)
  DateFormat formatter = DateFormat('yyyy.MM.dd HH:mm');

  // 3. 포맷 적용하여 String으로 변환
  String formattedDate = formatter.format(now);

  return formattedDate;
}