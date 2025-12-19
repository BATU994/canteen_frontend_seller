import 'package:canteen_frontend_seller/src/core/const/color.dart';
import 'package:canteen_frontend_seller/src/core/routers/destinations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => (Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: mainColor,
          destinations: destinations
              .map((destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    label: destination.label,
                    selectedIcon: Icon(
                      destination.icon,
                      color: Colors.white,
                    ),
                  ))
              .toList(),
        ),
      ));
}
