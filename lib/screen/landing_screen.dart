import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/app_layout.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 타이틀 영역
              Container(
                color: const Color(0xFFF2F6FF),
                padding: const EdgeInsets.fromLTRB(32, 64, 32, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '더치페이,\n정산을 가볍게',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '영수증·QR로 모임 정산을\n빠르게 마무리하세요.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 콘텐츠 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 버튼 영역
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/qr_scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B7BF6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('카카오로 시작하기', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('앱 설치 링크 받기'),
                    ),

                    const SizedBox(height: 48),

                    // 기능 설명 영역
                    const Text(
                      '이렇게 쓰세요',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem('영수증·항목으로 지출 정리'),
                    const SizedBox(height: 12),
                    _buildFeatureItem('정산 방식 선택 후 자동 계산'),
                    const SizedBox(height: 12),
                    _buildFeatureItem('참여자별 QR로 결제 요청'),

                    const SizedBox(height: 60), // Spacer 대신 고정 여백 사용 (스크롤 내부)

                    // 최하단 정보
                    Center(
                      child: Text(
                        '이용약관 · 개인정보처리방침',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFF3B7BF6), shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}