import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/main_button.dart';
import '../../widgets/otp_input_field.dart';
import '../../widgets/password_input_field.dart';
import '../../widgets/phone_input_field.dart';
import 'welcome_screen.dart';

const fhnLogo = 'assets/fhnlogo.png';

enum FhnState {
  reset,
  confirm,
  change,
  success,
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  FhnState fhnState = FhnState.reset;

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

  String _otp = '';
  void _updateOtp(String value) {
    setState(() {
      _otp = value;
    });
  }

  Future<void> _resetPassword(int type) async {
    if (type == 1) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        _formKey.currentState!.save();
        setState(() {
          isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).resetPassword(
          _phNumber,
        );
        setState(() {
          isLoading = false;
          fhnState = FhnState.confirm;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } else if (type == 2) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        _formKey.currentState!.save();
        setState(() {
          isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).resetPasswordConfirm(
          _phNumber,
          _otp,
        );
        setState(() {
          isLoading = false;
          fhnState = FhnState.change;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } else if (type == 3) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        _formKey.currentState!.save();
        setState(() {
          isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).changePassword(
          _phNumber,
          _password,
        );
        setState(() {
          isLoading = false;
          fhnState = FhnState.success;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
        ));
        setState(() {
          isLoading = false;
          fhnState = FhnState.success;
        });
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    }
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
                  fhnState != FhnState.success
                      ? const Text(
                          'Şifrəni yenilə',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Text(
                          'Şifrəniz uğurla yeniləndi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  const Divider(
                    height: 24,
                    color: Colors.white,
                  ),
                  fhnState != FhnState.success
                      ? const Text(
                          'Şifrənizi yeniləmək üçün qeyd olunan xanalar üzrə mobil nömrə və nömrənizə gələcək olan kodu daxil edin.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  fhnState == FhnState.reset
                      ? PhoneInputField(
                          'Telefon nömrəsi',
                          _fullNameController,
                          _updatePhNumber,
                        )
                      : const SizedBox(),
                  fhnState == FhnState.change
                      ? PasswordInputField(
                          'Şifrə',
                          _passwordController,
                          _updatePassword,
                        )
                      : const SizedBox(),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  fhnState == FhnState.confirm
                      ? OtpInputField(
                          '4 reqemli kod',
                          _otpController,
                          _updateOtp,
                        )
                      : const SizedBox(),
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
                        'Davam et',
                        const Color(0XFF262626),
                        const Color(0XFF262626),
                        Colors.white,
                        fhnState == FhnState.reset
                            ? () async => await _resetPassword(1)
                            : fhnState == FhnState.confirm
                                ? () async => await _resetPassword(2)
                                : fhnState == FhnState.change
                                    ? () async => await _resetPassword(3)
                                    : () async => await _resetPassword(4),
                      ),
                const Divider(
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
