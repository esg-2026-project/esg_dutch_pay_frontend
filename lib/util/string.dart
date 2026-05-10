// 금액 콤마 포맷팅 헬퍼 함수
String formatCurrency(int amount) {
  return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},'
  );
}