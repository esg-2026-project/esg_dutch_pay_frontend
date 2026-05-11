import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:convert';

// 자바스크립트 전역 PortOne 객체 정의
@JS('PortOne')
external JSAny? get portOne; // 여기서 JSAny?로 선언하여 안전하게 가져옵니다.

class PortOneWeb {
  static void requestPayment({
    required int amount,
    required String orderName,
    required Function(Map<String, dynamic>) onResult,
  }) async {
    // 1. 결제 데이터 생성
    final paymentData = {
      'storeId': 'store-052e1227-c7a7-45c5-9fa3-2bd1da1a0a49',
      'channelKey': 'channel-key-2f02b625-3d2b-4fa8-80f7-ca61e56ca37a',
      'paymentId': 'payment_${DateTime.now().millisecondsSinceEpoch}',
      'orderName': orderName,
      'totalAmount': amount,
      'currency': 'CURRENCY_KRW',
      'payMethod': 'CARD',
    }.jsify();

    try {
      // 2. portOne 객체가 존재하는지 먼저 확인
      if (portOne == null) {
        onResult({'code': 'ERROR', 'message': 'PortOne SDK가 로드되지 않았습니다.'});
        return;
      }

      // 3. requestPayment 호출 (JSAny를 JSObject로 캐스팅)
      final po = portOne as JSObject;
      final JSPromise promise = po.callMethod('requestPayment'.toJS, paymentData!);

      // 4. Promise 대기 및 결과 처리
      final JSAny? response = await promise.toDart;

      if (response != null) {
        final String jsonString = _stringify(response);
        onResult(jsonDecode(jsonString));
      } else {
        onResult({'code': 'FAILURE', 'message': '응답값이 없습니다.'});
      }

    } catch (e) {
      onResult({
        'code': 'FAILURE',
        'message': e.toString(),
      });
    }
  }
}

// JSON.stringify 선언 시 파라미터 타입을 JSAny로 넓혀줍니다.
@JS('JSON.stringify')
external String _stringify(JSAny obj);