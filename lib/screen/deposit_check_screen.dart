import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DepositCheckScreen extends StatelessWidget {
  const DepositCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('입금 확인')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('진행 상태', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('3/4명 완료', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: 0.75, backgroundColor: Colors.grey[200], color: Colors.blue, minHeight: 8),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildDepositRow('김나영', '30,000원', true),
                  _buildDepositRow('이동욱', '30,000원', true),
                  _buildDepositRow('최수연', '30,000원', true),
                  _buildDepositRow('박지민', '30,000원', false),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('미납자 알림 보내기'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/history')),
              child: const Text('정산 완료로 마무리'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDepositRow(String name, String amount, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Text(amount, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDone ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isDone ? '완료' : '미납',
              style: TextStyle(color: isDone ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}