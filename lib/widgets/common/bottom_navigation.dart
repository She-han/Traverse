import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: appProvider.currentIndex,
          onTap: (index) {
            appProvider.setCurrentIndex(index);
            switch (index) {
              case 0:
                context.go('/map');
                break;
              case 1:
                context.go('/timetable');
                break;
              case 2:
                context.go('/route-planner');
                break;
              case 3:
                context.go('/favorites');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Timetable',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions),
              label: 'Routes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        );
      },
    );
  }
}

