import 'package:flutter/material.dart';
import 'package:frontend/screen/deposit_check_screen.dart';
import 'package:frontend/screen/landing_screen.dart';
import 'package:frontend/screen/portone/identity_verification.dart';
import 'package:frontend/screen/portone/port_one_screen.dart';
import 'package:frontend/screen/qr_code_scan_screen.dart';
import 'package:frontend/screen/qr_payment_screen.dart';
import 'package:frontend/screen/remittance_request_screen.dart';
import 'package:frontend/screen/settlement_history_screen.dart';
import 'package:frontend/screen/split_result_screen.dart';
import 'package:frontend/screen/split_setup_screen.dart';


void main() {
  runApp(const DutchPaymentService());
}

class DutchPaymentService extends StatelessWidget {
  const DutchPaymentService({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '더치페이 랜딩',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LandingScreen(),
        '/qr_scan': (context) => const QrScanScreen(),
        '/qr_payment': (context) => const QrPaymentScreen(),
        '/remittance_request_screen': (context) => RemittanceRequestScreen(),
        '/deposit_check_screen': (context) => DepositCheckScreen(),
        '/settlement_history_screen': (context) => const SettlementHistoryScreen(),
        '/split_setup': (context) => const SplitSetupScreen(),
        '/split_result': (context) => const SplitResultScreen(),
        '/port_one': (context) => const PortOneScreen(),
        '/identity_verification': (context) => const IdentityVerification()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}