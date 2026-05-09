import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class SplitSetupScreen extends StatelessWidget {
  const SplitSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participants = ['김나영', '김동현', '박지민', '유지호', '이준규'];

    return AppLayout(
      title: '정산 테이블',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('참여자 추가', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 검색창
            TextField(
              decoration: InputDecoration(
                hintText: '이름 검색',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 참여자 리스트 카드
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: kCardShadow,
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: participants.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: kPrimaryColor.withOpacity(0.1),
                        child: Text(
                          participants[index][0],
                          style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(participants[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.check_circle, color: kPrimaryColor),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 하단 버튼
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/split_result'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('다음으로', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}