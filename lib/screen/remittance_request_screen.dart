import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemittanceRequestScreen extends StatelessWidget {
  const RemittanceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('송금 보내기 요청')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('요청 금액', style: TextStyle(color: Colors.blue)),
                  const SizedBox(height: 8),
                  const Text('72,000원', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Divider(height: 32),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('카카오뱅크'),
                    TextButton(onPressed: (){}, child: const Text('계좌 복사'))
                  ]),
                  const Text('3333-12-345678 김나영', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('본인 제외', '36,000원'),
            const Divider(),
            _buildDetailRow('박지민', '12,000원'),
            _buildDetailRow('유지호', '24,000원'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              child: const Text('정산 완료로 변경'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}