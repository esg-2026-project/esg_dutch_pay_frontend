import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettlementHistoryScreen extends StatelessWidget {
  const SettlementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('정산 내역'),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [Tab(text: '진행 중'), Tab(text: '완료')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHistoryCard(context, '주말 볼링모임', '총 금액 72,000원', '진행 중', Colors.blue),
                _buildHistoryCard(context, '회사 회식', '총 금액 120,000원', '완료', Colors.grey),
                _buildHistoryCard(context, '생일 파티', '총 금액 80,000원', '완료', Colors.grey),
              ],
            ),
            const Center(child: Text('완료된 내역이 없습니다.')),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String title, String subtitle, String status, Color statusColor) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/deposit_check'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}