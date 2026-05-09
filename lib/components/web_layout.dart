import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// [공통 레이아웃] 웹 대응
class WebLayout extends StatelessWidget {
  final Widget child;
  const WebLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 850, maxWidth: 420),
          child: child,
        ),
      ),
    );
  }
}