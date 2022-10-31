import 'package:flutter/material.dart';
import 'package:e_commerce/presentation/screens/screens.dart';

class BottomNavigation extends StatefulWidget {
  final int? routeIndex;
  const BottomNavigation({Key? key, this.routeIndex}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;
  static const List<Widget> _navigationBarScreenList = <Widget>[
    HomeScreen(),
    FavoriteScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.routeIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SafeArea(child: _navigationBarScreenList.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'รายการโปรด',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'การแจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
