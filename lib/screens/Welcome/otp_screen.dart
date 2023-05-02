import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/main_button.dart';
import '../../widgets/otp_input_field.dart';
import '../../widgets/phone_input_field.dart';
import 'register_screen.dart';

const fhnLogo = 'assets/fhnlogo.png';

enum Register {
  number,
  otp,
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Register _registerState = Register.number;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  String _phNumber = '';
  String _otp = '';
  void _updateOtp(String value) {
    setState(() {
      _otp = value;
    });
  }

  void _updatePhNumber(String value) {
    setState(() {
      _phNumber = value;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).otp(_phNumber);
      setState(() {
        isLoading = false;
      });
      loginFunc();
    } catch (error) {
      // Error occurred, display error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Xeta: $error'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).checkOtp(_phNumber, _otp);
      setState(() {
        isLoading = false;
      });
      loginFunc();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Xeta: $error'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginFunc() {
    if (_registerState == Register.number) {
      setState(() {
        _registerState = Register.otp;
      });
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegisterScreen(_phNumber)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      _registerState == Register.number
                          ? 'Mobil nömrə'
                          : 'Təsdiq kodu',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(
                      height: 24,
                      color: Colors.white,
                    ),
                    Text(
                      _registerState == Register.number
                          ? 'Qeydiyyatdan keçmək üçün mobil nömrənizi daxil edin.'
                          : 'Mobil nömrənizə göndərilmiş 4 rəqəmli təsdiq kodunu daxil edin.',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      height: 24,
                      color: Colors.white,
                    ),
                    _registerState == Register.number
                        ? PhoneInputField(
                            'Mobil nömrə',
                            _phoneNumberController,
                            _updatePhNumber,
                          )
                        : OtpInputField(
                            'Təsdiq kodu',
                            _otpController,
                            _updateOtp,
                          )
                  ],
                ),
              ),
              Container(),
              Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : MainButton(
                          'Davam et',
                          Colors.white,
                          Colors.black,
                          Colors.black,
                          _registerState == Register.number
                              ? () async => await _submitForm()
                              : () async => await _submitOtp(),
                        ),
                  const Divider(
                    height: 16,
                    color: Colors.white,
                  ),
                  // MainButton(
                  //   'Sign up',
                  //   Color(0XFF262626),
                  //   Color(0XFF262626),
                  //   Colors.white,
                  //   () => signFunction,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
