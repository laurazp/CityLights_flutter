import 'package:citylights/presentation/navigation/navigation_routes.dart';
import 'package:citylights/presentation/view/map/map_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
    //return const MaterialApp(home: MapPage(),);
  }
}
