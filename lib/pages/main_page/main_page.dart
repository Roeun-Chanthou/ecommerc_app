import 'package:ecommerc_app/pages/home_page/home.dart';
import 'package:ecommerc_app/pages/settings/setting.dart';
import 'package:ecommerc_app/pages/wishlist/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          WishListScreen(),
          Setting(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(
            () {
              currentIndex = value;
            },
          );
        },
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? SvgPicture.asset(
                    "assets/home_solid.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  )
                : SvgPicture.asset(
                    "assets/home 03.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? SvgPicture.asset(
                    "assets/love_solid.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  )
                : SvgPicture.asset(
                    "assets/love.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? SvgPicture.asset(
                    "assets/setting_solid.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  )
                : SvgPicture.asset(
                    "assets/setting.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
