import 'package:citylights/presentation/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/loading_animation.json',
          repeat: false,
          animate: true,
          width: 275,
          height: 275,
        ),
      ),
    );
  }

  _navigateToNextPage() async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        context.go(NavigationRoutes.MONUMENTS_ROUTE);
      }
    } catch (e) {
      print('Navigation error: $e');
    }
  }
}
