import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 스캐너 패키지 임포트

import '../components/app_layout.dart';
import '../util/color.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  // 카메라 제어를 위한 컨트롤러
  final MobileScannerController cameraController = MobileScannerController();

  // 중복 스캔을 방지하기 위한 플래그
  bool _isScanned = false;

  @override
  void dispose() {
    // 화면이 꺼질 때 카메라 자원 해제
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      backgroundColor: const Color(0xFF111111),
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('QR 코드 스캔', style: TextStyle(color: Colors.white)),
          ),
          const Spacer(),
          const Text('QR 코드를 사각형 안에 맞춰주세요.', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 40),

          // [수정된 부분] 실제 스캐너 영역
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21), // 테두리 안쪽 둥글기 맞춤
              child: MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  // 이미 스캔된 상태면 무시 (중복 화면 이동 방지)
                  if (_isScanned) return;

                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() {
                        _isScanned = true;
                      });

                      final String qrData = barcode.rawValue!;
                      debugPrint('QR 코드 인식 성공: $qrData');

                      // QR 코드가 인식되면 다음 화면으로 이동
                      // 실제로는 qrData를 인자로 넘겨주어 활용해야 합니다.
                      Navigator.pushNamed(context, '/split_setup').then((_) {
                        // 뒤로가기로 다시 돌아왔을 때 스캔이 다시 되도록 초기화
                        setState(() {
                          _isScanned = false;
                        });
                      });
                      break;
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 60),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 플래시 버튼 동작 연결
              GestureDetector(
                onTap: () => cameraController.toggleTorch(),
                child: _buildIconButton(Icons.flash_on, '플래시'),
              ),
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