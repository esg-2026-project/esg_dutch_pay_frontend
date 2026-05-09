import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class SettlementHistoryScreen extends StatelessWidget {
  const SettlementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppLayout(
        title: '정산 내역',
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kPrimaryColor,
                indicatorWeight: 3,
                tabs: [Tab(text: '진행 중'), Tab(text: '완료')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildHistoryCard(context, '주말 볼링모임', '72,000원', '진행 중', kPrimaryColor),
                      _buildHistoryCard(context, '회사 회식', '120,000원', '완료', Colors.grey),
                    ],
                  ),
                  const Center(child: Text('완료된 내역이 없습니다.')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String title, String amount, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kCardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('총 금액 $amount', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}