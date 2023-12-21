import 'package:citylights/di/app_modules.dart';
import 'package:citylights/presentation/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';

void main() {
  AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false, routerConfig: router);
  }
}
