import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../util/color.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      backgroundColor: const Color(0xFF111111),
      child: Column(
        children: [
          AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: () => Navigator.pushReplacementNamed(context, '/login'),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('QR 코드 스캔', style: TextStyle(color: Colors.white)),
          ),
          const Spacer(),
          const Text('QR 코드를 사각형 안에 맞춰주세요.', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 40),
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // 카메라 프리뷰가 들어갈 자리 (임시 박스)
                Center(child: Icon(Icons.qr_code_scanner, color: kPrimaryColor.withOpacity(0.3), size: 100)),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.flash_on, '플래시'),
              const SizedBox(width: 48),
              _buildIconButton(Icons.photo_library, '앨범'),
            ],
          ),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/split_setup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('직접 입력해서 정산하기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}