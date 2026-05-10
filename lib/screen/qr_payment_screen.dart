import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/util/string.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class QrPaymentScreen extends StatefulWidget {
  const QrPaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final participants = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;

    return AppLayout(
      title: 'QR 결제',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('참여자들에게 QR 코드를 보여주세요.', style: TextStyle(color: Colors.grey, fontSize: 15)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: participants.map((element) {
                  return _buildQrCard(element['name'], "${formatCurrency(element['amount'] as int)}원");
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/deposit_check_screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('정산 진행 상황 확인', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 54),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('결제 링크 공유하기', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCard(String name, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            child: Text(name[0], style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(amount, style: const TextStyle(color: Colors.black87, fontSize: 15)),
              ],
            ),
          ),
          const Icon(Icons.qr_code_2, size: 40, color: Colors.black87),
        ],
      ),
    );
  }
}