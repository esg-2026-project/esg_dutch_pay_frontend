import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/guide_components.dart';

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

      try {
        final String origin = web.window.location.origin;
        final String hash = web.window.location.hash;

        final String newUrl = "$origin/$hash";
        web.window.history.replaceState(null, '', newUrl);
      } catch (e) {
        print("URL cleaning error: $e");
      }
    }
  }

  List<Map<String, dynamic>> getParticipants(Object? args) {
    List<Map<String, dynamic>> participants = [];
    if (args != null) {
      participants = args as List<Map<String, dynamic>>;
      web.window.localStorage.setItem('backup_participants', jsonEncode(participants));
    } else {
      final savedData = web.window.localStorage.getItem('backup_participants');

      if (savedData != null) {
        final List<dynamic> decodedList = jsonDecode(savedData);
        participants = decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        return List.empty();
      }
    }
    return participants;
  }

  @override
  Widget build(BuildContext context) {
    final participants = getParticipants(ModalRoute.of(context)?.settings.arguments);

    if (participants.isEmpty) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    final myStatus = participants.firstWhere((people) => people['isOwner']);

    final int totalCount = participants.length;
    final int doneCount = participants.where((people) => people['isDone'] == true).length;
    final bool hasUnpaid = doneCount < totalCount;
    final double progressValue = totalCount > 0 ? doneCount / totalCount : 0.0;

    final bool canOwnerPay = participants
        .where((people) => people['isOwner'] != true)
        .every((people) => people['isDone'] == true);

    return AppLayout(
      title: '입금 확인',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // [수정] 전체 화면(버튼 제외 상단 전체)을 CustomScrollView로 감쌉니다.
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      // TODO: API 호출 로직
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {});
                    },
                  ),

                  // 일반 위젯들을 담는 SliverToBoxAdapter
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 16),

                        // [추가] 안내 알림 텍스트 상자
                        GuideComponents(guidingText: '화면을 아래로 당겨서 새로고침 한 후, 다른 사람들이 정산을 완료하면 결제할 수 있어요.',),

                        // 실패 경고창 (안내 텍스트 아래에 위치)
                        if (isFailedPayment) ...[
                          const SizedBox(height: 12),
                          WarnComponents(text: '결제에 실패했습니다.')
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // 리스트 영역
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

            // 결제하기 버튼 (화면 하단에 고정)
            ElevatedButton(
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
                disabledBackgroundColor: Colors.grey[300],
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                  canOwnerPay ? '결제하기' : '다른 인원 결제 대기중',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: canOwnerPay ? Colors.white : Colors.grey[500],
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