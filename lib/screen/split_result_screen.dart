import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplitResultScreen extends StatelessWidget {
  const SplitResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('정산 결과')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('총 금액', style: TextStyle(color: Colors.grey)),
            const Text('120,000원', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('정산 방식 선택', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(value: 1, groupValue: 1, onChanged: (v){}, title: const Text('균등 분할'), subtitle: const Text('모든 인원이 동일한 금액을 냅니다.'), contentPadding: EdgeInsets.zero),
            RadioListTile(value: 2, groupValue: 1, onChanged: (v){}, title: const Text('금액 직접 입력'), contentPadding: EdgeInsets.zero),
            const Divider(height: 40),
            const Text('참여자별 정산 결과', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildResultRow('김나영', '30,000원', Colors.blue),
            _buildResultRow('김동현', '30,000원', Colors.blue),
            _buildResultRow('박지민', '30,000원', Colors.blue),
            _buildResultRow('유지호', '30,000원', Colors.blue),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/qr_payment'),
              child: const Text('결제 요청하기'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String name, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: color, child: Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 12))),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}