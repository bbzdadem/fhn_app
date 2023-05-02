import 'package:flutter/material.dart';

import '../../widgets/main_button.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

const fhnLogo = 'assets/fhnlogo.png';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void loginFunc() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    }

    void signFunction() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const OtpScreen()));
    }

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                fhnLogo,
                width: 137,
              ),
              Column(
                children: const [
                  Text(
                    'Xoş gəldiniz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Divider(
                    height: 24,
                    color: Colors.white,
                  ),
                  Text(
                    'Tətbiq vasitəsi ilə ətrafınızda baş verən hadisələri rahatlıqla Fövqaladə Hallar Nazirliyinə göndərə biləcəksiniz.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(),
              Column(
                children: [
                  MainButton(
                    'Daxil ol',
                    Colors.white,
                    Colors.black,
                    Colors.black,
                    () => loginFunc(),
                  ),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  MainButton(
                    'Qeydiyyatdan keç',
                    const Color(0XFF262626),
                    const Color(0XFF262626),
                    Colors.white,
                    () => signFunction(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
