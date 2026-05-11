import 'package:flutter/material.dart';
import 'package:portone_flutter/v2/model/response/payment_response.dart';
import '../components/app_layout.dart';
import '../util/color.dart';
import '../util/string.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 결제 결과 데이터를 받아옵니다 (전달된 경우)
    final result = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String amount = formatCurrency(result['amount'] ?? 0);

    return AppLayout(
      title: '결제 완료',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // 1. 성공 아이콘 (그린 체크)
            const Icon(
              Icons.check_circle_rounded,
              color: kPrimaryColor,
              size: 72,
            ),
            const SizedBox(height: 24),
            // 2. 주 메시지
            const Text(
              '결제가 완료되었습니다!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '정산 내역이 성공적으로 업데이트되었습니다.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            // 3. 결제 상세 정보 카드 (기존 디자인 스타일 유지)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: [
                  _buildInfoRow('결제 금액', '$amount원', isBold: true),
                  const Divider(height: 32, color: Color(0xFFE8E8E8),),
                  _buildInfoRow('결제 수단', '토스페이'),
                  const SizedBox(height: 12),
                  _buildInfoRow('결제 일시', formatCurrentDate()),
                ],
              ),
            ),
            const Spacer(),
            // 4. 확인 버튼 (홈으로 이동)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                '확인',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? kPrimaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }
}
