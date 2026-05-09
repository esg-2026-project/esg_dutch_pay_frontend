import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const AppLayout({
    super.key,
    this.title,
    required this.child,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8), // 브라우저 전체 배경
      appBar: title != null
          ? PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // 기본 AppBar 높이
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AppBar(
              title: Text(
                  title!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor ?? kBackgroundColor,
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: bottomNavigationBar,
        ),
      )
          : null,
    );
  }
}