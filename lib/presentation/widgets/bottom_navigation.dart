import 'package:flutter/material.dart';
import 'package:marketplace/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marketplace/cubits/cubits.dart';

import '../../routes/screens_routes.dart';

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
    void navigateToNoAuth(int index) {
      if (index == 1 || index == 2) {
        Navigator.pushNamed(context, loginRoute);
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SafeArea(child: _navigationBarScreenList.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.14),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: state is UserLoaded ? _onItemTapped : navigateToNoAuth,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'หน้าแรก',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline),
                  activeIcon: Icon(Icons.favorite),
                  label: 'รายการโปรด',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      BlocBuilder<NotificationCubit, NotificationState>(
                        builder: (context, state) {
                          if (context.read<NotificationCubit>().isReadAll()) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 10,
                                minHeight: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  activeIcon: const Icon(Icons.notifications),
                  label: 'การแจ้งเตือน',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'โปรไฟล์',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
