import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class RemittanceRequestScreen extends StatelessWidget {
  const RemittanceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: '송금 요청',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: [
                  const Text('나에게 보낼 금액', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  const SizedBox(height: 8),
                  const Text('72,000원', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: kPrimaryColor)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('카카오뱅크 3333-12-345678', style: TextStyle(fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('복사', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildDetailRow('본인 제외 인원', '3명'),
            _buildDetailRow('박지민', '24,000원'),
            _buildDetailRow('유지호', '24,000원'),
            _buildDetailRow('김동현', '24,000원'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('카카오톡으로 공유하기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}