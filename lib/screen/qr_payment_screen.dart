import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QrPaymentScreen extends StatelessWidget {
  const QrPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 결제')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('참여자들에게 QR 코드를 보여주세요.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildQrRow('김나영', '12,500원', Colors.blue),
                  _buildQrRow('김동현', '12,500원', Colors.green),
                  _buildQrRow('박지민', '12,500원', Colors.purple),
                  _buildQrRow('유지호', '12,500원', Colors.orange),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/request'),
              child: const Text('결제 링크 공유 및 복사'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrRow(String name, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: color, child: Text(name[0], style: const TextStyle(color: Colors.white))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(amount, style: const TextStyle(fontSize: 16)),
                ],
              )
            ],
          ),
          const Icon(Icons.qr_code_2, size: 48), // QR 코드 임시 아이콘
        ],
      ),
    );
  }
}