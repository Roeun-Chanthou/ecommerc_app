import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  String username;
  Setting({super.key, this.username = ""});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late String username;
  @override
  void initState() {
    super.initState();
    username = widget.username;
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? '';
    });

    bool showWelcomeDialog = prefs.getBool('showWelcomeDialog') ?? false;
    if (showWelcomeDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeDialog();
      });
      await prefs.setBool('showWelcomeDialog', false);
    }
  }

  void _showWelcomeDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: username,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      desc: 'Welcome $username',
      descTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      autoHide: const Duration(seconds: 2),
    ).show();
  }

  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${username}",
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
            Bounceable(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.darkMode,
                );
              },
              child: _buildListTitle(
                image: "assets/bill.svg",
                title: "My Orders",
              ),
            ),
            const Divider(height: 0),
            _buildListTitle(
              image: "assets/globe.svg",
              title: "Change Language",
            ),
            const SizedBox(height: 20),
            _buildListTitle(
              image: "assets/information.svg",
              title: "About",
            ),
            const Divider(height: 0),
            _buildListTitle(
              image: "assets/notepad.svg",
              title: "Privacy Policy",
            ),
            const SizedBox(height: 20),
            Bounceable(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.darkMode,
                );
              },
              child: _buildListTitle(
                image: "assets/dark-mode-alt-2.svg",
                title: "Dark Theme",
              ),
            ),
            const Divider(height: 0),
            Bounceable(
              onTap: _logout,
              child: _buildListTitle(
                image: "assets/logout 01.svg",
                title: "Log out",
              ),
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.login,
      (route) => false,
    );
  }
}
