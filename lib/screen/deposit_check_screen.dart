import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/app_layout.dart';
import '../components/warn_components.dart';
import '../util/color.dart';
import '../util/payment_web.dart';
import '../util/string.dart';

import 'package:web/web.dart' as web show window;

class DepositCheckScreen extends StatefulWidget {
  const DepositCheckScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DepositCheckScreenState();
}

class _DepositCheckScreenState extends State<DepositCheckScreen> {
  bool isFailedPayment = false;
  String paymentCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirectResult();
    });
  }

  void _handleRedirectResult() {
    final params = getRawQueryParams();
    final String? paymentId = params['paymentId'];
    final String? code = params['code'];

    if (paymentId != null) {
      if (code == null) {
        // 성공 시 결과 페이지로 이동 (금액 정보 등은 localStorage에서 가져와도 됨)
        Navigator.pushReplacementNamed(
            context,
            '/result',
            arguments: {'amount': 30000}
        );
      } else {
        // 실패 시 이 화면에 머물며 에러 표시
        setState(() {
          isFailedPayment = true;
          paymentCode = code;
        });
      }

      // 처리 후 URL 파라미터 청소 (다시 새로고침 시 로직 중복 방지)
      web.window.history.replaceState(null, '', web.window.location.pathname + web.window.location.hash);
    }
  }

  List<Map<String, dynamic>> getParticipants(Object? args) {
    List<Map<String, dynamic>> participants = [];
    // 2. 데이터 복구 로직
    if (args != null) {
      // 정상적으로 화면에 진입한 경우 (결제 전)
      participants = args as List<Map<String, dynamic>>;
      // 모바일 결제 이탈을 대비해 브라우저 로컬 스토리지에 데이터를 백업해 둡니다.
      web.window.localStorage.setItem('backup_participants', jsonEncode(participants));
    } else {
      // 리다이렉트로 돌아와서 args가 null이 된 경우 (결제 후)
      final savedData = web.window.localStorage.getItem('backup_participants');

      if (savedData != null) {
        // 로컬 스토리지에서 백업 데이터를 꺼내서 복구합니다.
        final List<dynamic> decodedList = jsonDecode(savedData);
        participants = decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        // 백업 데이터마저 없다면 (비정상 접근 등) 안전하게 에러 화면이나 로딩 띄우기
        return List.empty();
      }
    }
    return participants;
  }

  @override
  Widget build(BuildContext context) {
    final participants = getParticipants(ModalRoute.of(context)!.settings.arguments);
    final myStatus = participants.firstWhere((people) => people['isOwner']);

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
            if (isFailedPayment) ...[
              const SizedBox(height: 16,),
              WarnComponents(text: '결제에 실패했습니다.')
            ],
            const SizedBox(height: 16),
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
              onPressed: () {
                if (kIsWeb) {
                  PortOneWeb.requestPayment(
                    amount: myStatus['amount'],
                    orderName: '정산 결제',
                    onResult: (result) {
                      print("result : ${result}");
                      if((result['info']['code'] as String).contains('FAILURE')) {
                        setState(() {
                          isFailedPayment = true;
                          paymentCode = result['info']['code'];
                        });
                      } else {
                        // 결과에 따라 성공 페이지로 이동
                        setState(() {
                          myStatus['isDone'] = true;
                        });
                        Navigator.pushNamed(context, '/result', arguments: result);
                      }
                    },
                  );
                } else {
                  // 모바일인 경우 기존 PortOneScreen으로 이동
                  Navigator.pushNamed(context, '/portone');
                }
              },
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