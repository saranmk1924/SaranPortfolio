import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/common/intro_view.dart';

class MobileIntroView extends StatefulWidget {
  const MobileIntroView({super.key});

  @override
  State<MobileIntroView> createState() => _MobileIntroViewState();
}

class _MobileIntroViewState extends State<MobileIntroView> {
  @override
  Widget build(BuildContext context) {
    return const IntroView();
  }
}