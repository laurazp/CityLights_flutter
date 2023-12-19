import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (value) {
            widget.navigationShell.goBranch(value,
                initialLocation: value == widget.navigationShell.currentIndex);
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_work_outlined),
                selectedIcon: Icon(Icons.home_work),
                label: "Monuments"),
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: "Map"),
            NavigationDestination(
                icon: Icon(Icons.star_border_outlined),
                selectedIcon: Icon(Icons.star),
                label: "Favorites")
          ]),
      /*BottomNavigationBar(items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            tooltip: "This is the home page"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined), label: "Profile"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: "Settings")
      ]),*/
    );
  }
}
