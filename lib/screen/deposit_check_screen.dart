import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';
import '../util/string.dart';

class DepositCheckScreen extends StatefulWidget {
  const DepositCheckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DepositCheckScreenState();
}

class _DepositCheckScreenState extends State<DepositCheckScreen> {

  @override
  Widget build(BuildContext context) {
    final participants = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;

    // [개선] 하드코딩 대신 실제 데이터 기반으로 진행 상태 계산
    final int totalCount = participants.length;
    final int doneCount = participants.where((people) => people['isDone'] == true).length;
    final bool hasUnpaid = doneCount < totalCount; // 미납자 존재 여부
    final double progressValue = totalCount > 0 ? doneCount / totalCount : 0.0;

    return AppLayout(
      title: '입금 확인',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 상태 요약 카드
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('진행 상태', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      // [추가] 미납자가 있을 경우 우측 상단에 텍스트 표시
                      if (hasUnpaid)
                        const Text('미납자가 있습니다', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('$doneCount/$totalCount명 완료', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: kPrimaryColor.withOpacity(0.1),
                      color: kPrimaryColor,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: participants.map((people) {
                  return _buildDepositRow(people['name'], "${formatCurrency(people['amount'] as int)}원", people['isDone']);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // [수정] 정산 완료 및 미납자 알림 버튼을 제거하고 '결제하기' 버튼 하나로 통일
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/port_one'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('결제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositRow(String name, String amount, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(amount, style: const TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isDone ? '완료' : '미납',
                  style: TextStyle(color: isDone ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}