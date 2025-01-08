import 'package:ecommerc_app/pages/home_page/home.dart';
import 'package:ecommerc_app/pages/settings/setting.dart';
import 'package:ecommerc_app/pages/wishlist/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
          left: 20,
          right: 20,
          top: 10,
        ),
        child: GNav(
          onTabChange: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          tabBorderRadius: 15,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 900),
          gap: 6,
          color: Colors.grey[800],
          activeColor: Colors.black,
          iconSize: 20,
          tabBackgroundColor: Colors.purple.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          tabs: [
            GButton(
              icon: Icons.home,
              iconColor: Colors.white,
              leading: currentIndex == 0
                  ? SvgPicture.asset(
                      "assets/home_solid.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      "assets/home 03.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
              text: 'Home',
            ),
            GButton(
              icon: Icons.favorite,
              leading: currentIndex == 1
                  ? SvgPicture.asset(
                      "assets/love_solid.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      "assets/love.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
              text: 'Wishlist',
            ),
            GButton(
              icon: Icons.settings,
              leading: currentIndex == 2
                  ? SvgPicture.asset(
                      "assets/setting_solid.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      "assets/setting.svg",
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
              text: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
