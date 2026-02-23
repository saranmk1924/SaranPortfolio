import 'package:flutter/material.dart';
import 'package:saranportfolio/feature/intro/presentation/pages/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaranPortfolioApp());
}

class SaranPortfolioApp extends StatelessWidget {
  const SaranPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saran Portfolio',
      theme: ThemeData.dark(),
      home: const IntroPage(),
    );
  }
}
