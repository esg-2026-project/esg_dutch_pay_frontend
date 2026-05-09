import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplitSetupScreen extends StatelessWidget {
  const SplitSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final participants = ['김나영', '김동현', '박지민', '유지호', '이준규'];

    return Scaffold(
      appBar: AppBar(title: const Text('정산 테이블 생성')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('참여자 추가', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '이름 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: participants.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.grey[300], child: const Icon(Icons.person, color: Colors.white)),
                    title: Text(participants[index]),
                    trailing: const Icon(Icons.check_circle_outline, color: Colors.grey),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/result'),
              child: const Text('다음'),
            )
          ],
        ),
      ),
    );
  }
}