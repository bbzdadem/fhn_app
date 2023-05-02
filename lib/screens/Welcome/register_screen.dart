import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/main_button.dart';
import '../../widgets/password_input_field.dart';
import '../../widgets/text_input_field.dart';
import 'login_screen.dart';

const fhnLogo = 'assets/fhnlogo.png';

class RegisterScreen extends StatefulWidget {
  String phoneNumber;
  RegisterScreen(this.phoneNumber, {Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dateFormatter = DateFormat('dd-MM-yyyy');

  bool isLoading = false;
  bool isRegister = false;
  String gender = '';
  String _firstName = '';
  void _updatefirstName(String value) {
    setState(() {
      _firstName = value;
    });
  }

  String _lastName = '';
  void _updatelastName(String value) {
    setState(() {
      _lastName = value;
    });
  }

  String _password = '';
  void _updatePassword(String value) {
    setState(() {
      _password = value;
    });
  }

  String _dateofBirth = '';

  @override
  Widget build(BuildContext context) {
    Future<void> _register() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        _formKey.currentState!.save();
        setState(() {
          isLoading = true;
        });
        print(
            '$_firstName, $_lastName, $_password, $gender, ${widget.phoneNumber}, $_dateofBirth');
        await Provider.of<Auth>(context, listen: false).register(
          _firstName,
          _lastName,
          _password,
          gender == 'male' ? 1 : 0,
          dateFormatter.format(DateTime.parse(_dateofBirth)),
          widget.phoneNumber,
        );
        setState(() {
          isLoading = false;
          isRegister = true;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Xeta: $error'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    }

    void signFunction() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    }

    void _modalBottomSheetMenu() {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                height: 240.0,
                color: Colors.transparent,
                child: SizedBox(
                  height: 140,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime(1918, 5, 28),
                    dateOrder: DatePickerDateOrder.dmy,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _dateofBirth = newDateTime.toString().substring(0, 10);
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isRegister
                    ? Column(
                        children: [
                          const Text(
                            'Qeydiyyat tamamlandı',
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
                            'Zəhmət olmasa hesabınıza giriş edin!',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(
                            height: 24,
                            color: Colors.white,
                          ),
                          MainButton(
                            'Qeydiyyatdan keç',
                            const Color(0XFF262626),
                            const Color(0XFF262626),
                            Colors.white,
                            signFunction,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Text(
                            'Qeydiyyatdan keç',
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
                            'Qeydiyyatı tamamlamaq üçün göstərilən xanalara şəxsi məlumatlarınızı daxil edin!',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(
                            height: 16,
                            color: Colors.white,
                          ),
                          TextInputField(
                            'Ad',
                            _nameController,
                            _updatefirstName,
                          ),
                          const Divider(
                            height: 16,
                            color: Colors.white,
                          ),
                          TextInputField(
                            'Soyad',
                            _lastnameController,
                            _updatelastName,
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
                          const Divider(
                            height: 16,
                            color: Colors.white,
                          ),
                          GestureDetector(
                            onTap: _modalBottomSheetMenu,
                            child: AbsorbPointer(
                                child: _dateofBirth == ''
                                    ? calendarText('Doğum tarixi (gg-aa-iiii)')
                                    : calendarText(_dateofBirth
                                        .toString()
                                        .substring(0, 10))),
                          ),
                          const Divider(
                            height: 16,
                            color: Colors.white,
                          ),
                          const Divider(
                            height: 16,
                            color: Colors.white,
                          ),
                          // const TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(
                          //           borderSide: BorderSide(color: Colors.teal)),
                          //       hintText: ' Enter gender',
                          //       labelText: 'Gender',
                          //       prefixIcon: Icon(
                          //         Icons.type_specimen,
                          //         color: Colors.grey,
                          //       ),
                          //       suffixStyle: TextStyle(color: Colors.grey)),
                          // ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    title: const Text('Kişi'),
                                    value: 'male',
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value as String;
                                      });
                                    },
                                    groupValue: gender,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    title: const Text('Qadın'),
                                    value: 'female',
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value as String;
                                      });
                                    },
                                    groupValue: gender,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                Container(),
                Column(
                  children: [
                    const Divider(
                      height: 16,
                      color: Colors.white,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : MainButton(
                            'Qeydiyyatdan keç',
                            const Color(0XFF262626),
                            const Color(0XFF262626),
                            Colors.white,
                            () async => await _register(),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget calendarText(String text) {
  return Container(
    height: 48,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE4E9F2),
          width: 1,
        ),
        color: const Color(0XFFF7F9FC),
        borderRadius: BorderRadius.circular(4)),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xff8F9BB3),
        fontSize: 16,
      ),
    ),
  );
}
