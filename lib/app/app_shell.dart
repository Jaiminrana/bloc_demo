import 'package:flutter/material.dart';
import 'package:self/app/widget/offline_banner.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: OfflineBanner(),
        ),
      ],
    );
  }
}