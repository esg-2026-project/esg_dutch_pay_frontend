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

    // 결제 정보가 있을 때만 실행
    if (paymentId != null) {
      if (code == null) {
        // 성공 시 결과 페이지로 이동
        // 여기서 잠시 딜레이를 주어 청소 로직이 먼저 작동하게 할 수도 있습니다.
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
            context,
            '/result',
            arguments: {'amount': 30000},
          );
        });
      } else {
        setState(() {
          isFailedPayment = true;
          paymentCode = code;
        });
      }

      // [중요] 주소창에서 쿼리 파라미터를 완전히 제거
      // HTML5 History API를 사용하여 사용자에게 보이는 URL을 변경합니다.
      try {
        final String origin = web.window.location.origin;
        final String hash = web.window.location.hash; // #/deposit_check_screen 등

        // 파라미터(?)가 빠진 깨끗한 URL 생성
        final String newUrl = "$origin/$hash";
        web.window.history.replaceState(null, '', newUrl);
      } catch (e) {
        print("URL cleaning error: $e");
      }
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
        // 백업 데이터마저 없다면 빈 리스트 반환
        return List.empty();
      }
    }
    return participants;
  }

  @override
  Widget build(BuildContext context) {
    // [수정] 강제 Unwrapping(!)을 방지하기 위해 ?를 사용합니다.
    final participants = getParticipants(ModalRoute.of(context)?.settings.arguments);

    // 데이터가 유실되었을 경우 안전망
    if (participants.isEmpty) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    final myStatus = participants.firstWhere((people) => people['isOwner']);

    // 진행 상태 계산
    final int totalCount = participants.length;
    final int doneCount = participants.where((people) => people['isDone'] == true).length;
    final bool hasUnpaid = doneCount < totalCount; // 미납자 존재 여부
    final double progressValue = totalCount > 0 ? doneCount / totalCount : 0.0;

    // [추가] 방장(isOwner)을 제외한 나머지 모든 인원이 결제를 완료했는지 체크
    final bool canOwnerPay = participants
        .where((people) => people['isOwner'] != true)
        .every((people) => people['isDone'] == true);

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

            // [수정] ListView 대신 CustomScrollView와 CupertinoSliverRefreshControl 적용
            Expanded(
              child: CustomScrollView(
                // iOS처럼 항상 스크롤 가능하게 해야 당겨서 새로고침이 동작합니다.
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      // TODO: 여기에 서버에서 최신 결제 상태를 불러오는 API 호출 로직을 넣으세요.
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        // API 결과를 받아 participants 상태를 갱신
                      });
                    },
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      participants.map((people) {
                        return _buildDepositRow(
                            people['name'],
                            "${formatCurrency(people['amount'] as int)}원",
                            people['isDone']
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 결제하기 버튼
            ElevatedButton(
              // [수정] canOwnerPay가 true일 때만 함수를 할당하여 활성화, 아니면 null을 주어 비활성화
              onPressed: canOwnerPay ? () {
                if (kIsWeb) {
                  PortOneWeb.requestPayment(
                    amount: myStatus['amount'],
                    orderName: '정산 결제',
                    onResult: (result) {
                      if((result['info']['code'] as String).contains('FAILURE')) {
                        setState(() {
                          isFailedPayment = true;
                          paymentCode = result['info']['code'];
                        });
                      } else {
                        setState(() {
                          myStatus['isDone'] = true;
                        });
                        Navigator.pushNamed(context, '/result', arguments: result);
                      }
                    },
                  );
                } else {
                  Navigator.pushNamed(context, '/portone');
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                disabledBackgroundColor: Colors.grey[300], // 비활성화 시 배경색
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                // [수정] 상태에 따라 버튼 텍스트 변경
                  canOwnerPay ? '결제하기' : '다른 인원 결제 대기중',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: canOwnerPay ? Colors.white : Colors.grey[400],
                  )
              ),
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