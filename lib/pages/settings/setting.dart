import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Setting',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Bounceable(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.cart,
                );
              },
              child: SvgPicture.asset(
                "assets/cart 02.svg",
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.18,
                    height: screenWidth * 0.18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "L Y",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Billa",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LY HOU",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "14 January",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildListTitle(
              image: "assets/bill.svg",
              title: "My Orders",
            ),
            const Divider(
              height: 0,
            ),
            _buildListTitle(
              image: "assets/globe.svg",
              title: "Change Language",
            ),
            const SizedBox(height: 20),
            _buildListTitle(
              image: "assets/information.svg",
              title: "About",
            ),
            const Divider(
              height: 0,
            ),
            _buildListTitle(
              image: "assets/notepad.svg",
              title: "Privacy Policy",
            ),
            const SizedBox(height: 20),
            _buildListTitle(
              image: "assets/logout 01.svg",
              title: "Log out",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTitle({required String image, required String title}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: SvgPicture.asset(
          image,
          width: 24,
          height: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
