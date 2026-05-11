import 'package:flutter/material.dart';
import 'package:frontend/components/app_layout.dart';

/* 포트원 V2 본인인증 모듈을 불러옵니다. */
import 'package:portone_flutter/v2/portone_identity_verification.dart';
/* 포트원 V2 본인인증 데이터 모델을 불러옵니다. */
import 'package:portone_flutter/v2/model/request/identity_verification_request.dart';
import 'package:portone_flutter/v2/model/response/identity_verification_response.dart';

class IdentityVerification extends StatelessWidget {
  const IdentityVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        title: '본인 인증',
        child: PortoneIdentityVerification(
          /* 웹뷰 로딩 컴포넌트 */
          initialChild: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          /* [필수입력] 본인인증 데이터 */
          data: IdentityVerificationRequest(
            storeId: 'iamporttest_3',                  // 상점 ID
            identityVerificationId: 'iv_${DateTime.now().millisecondsSinceEpoch}', // 본인인증 ID
            channelKey: 'channel-key-2f02b625-3d2b-4fa8-80f7-ca61e56ca37a',            // 채널 키
          ),
          /* 앱 URL scheme */
          appScheme: 'example',
          /* [필수입력] 콜백 함수 */
          callback: (IdentityVerificationResponse response) {
            Navigator.pushReplacementNamed(
              context,
              '/result',
              arguments: response,
            );
          },
        )
    );
  }
}