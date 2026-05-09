import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class SplitResultScreen extends StatelessWidget {
  const SplitResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: '정산 결과',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 총 금액 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: const [
                  Text('총 결제 금액', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  SizedBox(height: 8),
                  Text('120,000원', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. 정산 방식 카드
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 12, bottom: 8),
                    child: Text('정산 방식 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: 1,
                    onChanged: (v) {},
                    activeColor: kPrimaryColor,
                    title: const Text('균등 분할', style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: const Text('모든 인원이 동일한 금액을 냅니다.'),
                  ),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  RadioListTile(
                    value: 2,
                    groupValue: 1,
                    onChanged: (v) {},
                    activeColor: kPrimaryColor,
                    title: const Text('금액 직접 입력', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. 참여자별 결과 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('참여자별 정산 결과', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildResultRow('김나영', '30,000원'),
                  _buildResultRow('김동현', '30,000원'),
                  _buildResultRow('박지민', '30,000원'),
                  _buildResultRow('유지호', '30,000원'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 하단 버튼
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/qr_payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('결제 요청하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: kPrimaryColor.withOpacity(0.1),
                child: Text(name[0], style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}