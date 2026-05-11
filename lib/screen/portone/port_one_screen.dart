import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/app_layout.dart';

/* 포트원 V2 결제 모듈을 불러옵니다. */
import 'package:portone_flutter/v2/portone_payment.dart';
/* 포트원 V2 결제 데이터 모델을 불러옵니다. */
import 'package:portone_flutter/v2/model/request/payment_request.dart';
import 'package:portone_flutter/v2/model/response/payment_response.dart';
import 'package:portone_flutter/v2/model/entity/payment_pay_method.dart';
import 'package:portone_flutter/v2/model/entity/currency.dart';

class PortOneScreen extends StatelessWidget {
  const PortOneScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return AppLayout(
        title: "결제",
        child: PortonePayment(
          /* 웹뷰 로딩 컴포넌트 */
          initialChild: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(radius: 16),
                  Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                  Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          /* [필수입력] 결제 데이터 */
          data: PaymentRequest(
            storeId: 'iamporttest_3',                                      // 상점 ID
            channelKey: 'channel-key-2f02b625-3d2b-4fa8-80f7-ca61e56ca37a',                                // 채널 키
            payMethod: PaymentPayMethod.CARD,                              // 결제수단
            orderName: '결제 테스트',                                // 주문명
            totalAmount: 1000,                                              // 결제금액
            currency: Currency.KRW,                                         // 화폐
            paymentId: 'payment_${DateTime.now().millisecondsSinceEpoch}', // 결제 ID
            appScheme: 'esg_dutch_pay_frontend',                                           // 앱 URL scheme
          ),
          /* [필수입력] 콜백 함수 */
          callback: (PaymentResponse response) {
            Navigator.pushReplacementNamed(
              context,
              '/result',
              arguments: {
                'amount' : 1000,
                'response' : response
              },
            );
          },
        )
    );
  }
}