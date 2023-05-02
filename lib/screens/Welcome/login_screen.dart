import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/main_button.dart';
import '../../widgets/password_input_field.dart';
import '../../widgets/phone_input_field.dart';
import '../Home/main_screen.dart';
import 'forgot_password_screen.dart';

const fhnLogo = 'assets/fhnlogo.png';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;
  String _phNumber = '';
  void _updatePhNumber(String value) {
    setState(() {
      _phNumber = value;
    });
  }

  String _password = '';
  void _updatePassword(String value) {
    setState(() {
      _password = value;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).login(
        _phNumber,
        _password,
      );
      setState(() {
        isLoading = false;
      });
      signFunction();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  void signFunction() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()));
  }

  void forgotFunction() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              fhnLogo,
              width: 137,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Daxil ol',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(
                    height: 24,
                    color: Colors.white,
                  ),
                  const Text(
                    'Tətbiqə daxil olmaq üçün qeyd olunan xanalar üzrə mobil nömrə və təyin etdiyiniz şifrəni daxil edin.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  PhoneInputField(
                    'Telefon nömrəsi',
                    _fullNameController,
                    _updatePhNumber,
                  ),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  PasswordInputField(
                    'Şifrə',
                    _passwordController,
                    _updatePassword,
                  ),
                ],
              ),
            ),
            Container(),
            Column(
              children: [
                // MainButton(
                //   'Login',
                //   Colors.white,
                //   Colors.black,
                //   Colors.black,
                //   () => loginFunc,
                // ),
                const Divider(
                  height: 16,
                  color: Colors.white,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : MainButton(
                        'Daxil ol',
                        const Color(0XFF262626),
                        const Color(0XFF262626),
                        Colors.white,
                        () async => await _login(),
                      ),
                const Divider(
                  height: 16,
                  color: Colors.white,
                ),
                InkWell(
                  onTap: forgotFunction,
                  child: const Text('Şifrəmi unutdum?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
