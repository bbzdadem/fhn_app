import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';
import '../../providers/auth.dart';
import 'contact_screen.dart';
import 'profile_screen.dart';
import 'terms_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Menyu',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              MenuItem('assets/profile.svg', 'Profil', 1, 1),
              MenuItem('assets/help.svg', 'Kömək', 1, 3),
              MenuItem('assets/terms.svg', 'Qaydalar və Şərtlər', 1, 2),
              MenuItem('assets/logout.svg', 'Çıxış et', 0, 1),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  String assetName;
  String menuText;
  int type;
  int screen;

  MenuItem(this.assetName, this.menuText, this.type, this.screen, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        type == 0
            ? {
                Auth().logout(),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyHomePage()))
              }
            : Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => screen == 1
                    ? const ProfileScreen()
                    : screen == 2
                        ? const TermsScreen()
                        : const ContactScreen()));
      }),
      child: Container(
        height: 24,
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              width: 20,
              height: 20,
              fit: BoxFit.scaleDown,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                menuText,
                style: TextStyle(
                  fontSize: 16,
                  color: type == 1 ? Colors.black : const Color(0XFFFF4D4F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
