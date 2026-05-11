import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class PaymentCallbackScreen extends StatefulWidget {
  const PaymentCallbackScreen({super.key});

  @override
  State<PaymentCallbackScreen> createState() => _PaymentCallbackScreenState();
}

class _PaymentCallbackScreenState extends State<PaymentCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleResult();
  }

  void _handleResult() {
    final uri = Uri.parse(web.window.location.href.replaceFirst('/#', ''));
    final params = uri.queryParameters;

    // 포트원 V2 리다이렉트 시 성공하면 code가 없고, 실패하면 code/message가 붙습니다.
    final String? paymentId = params['paymentId'];
    final String? code = params['code']; // 실패 시 존재하는 에러 코드

    if (paymentId != null && code == null) {
      // [성공] 결과 페이지로 이동 (결제 정보 포함)
      Navigator.pushReplacementNamed(context, '/result', arguments: {
        'paymentId': paymentId,
        'totalAmount': params['totalAmount'],
      });
    } else {
      // [실패] 이전 화면으로 돌아가며 에러 메시지 표시
      Navigator.pop(context); // 혹은 특정 화면으로 pushReplacement
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CupertinoActivityIndicator(radius: 16)), // 처리 중 로딩 표시
    );
  }
}