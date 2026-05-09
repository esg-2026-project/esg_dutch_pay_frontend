import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('QR 코드 스캔', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('QR 코드를 사각형 안에 맞춰주세요.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 40),
          // 스캔 영역 UI
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.flash_on, '플래시'),
              _buildIconButton(Icons.photo_library, '앨범'),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/remittance_request_screen'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, minimumSize: const Size(200, 50)),
            child: const Text('테스트: 다음 화면으로', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}