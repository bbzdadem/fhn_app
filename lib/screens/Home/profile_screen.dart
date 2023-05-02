import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          'Profil',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final prefs = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ad'),
                const Divider(
                  height: 6,
                  color: Colors.transparent,
                ),
                Text(
                  prefs!.getString('name').toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 62, 139, 255),
                  ),
                ),
                const Divider(
                  height: 24,
                  color: Colors.transparent,
                ),
                const Text('Soyad'),
                const Divider(
                  height: 6,
                  color: Colors.transparent,
                ),
                Text(
                  prefs.getString('lastname').toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 62, 139, 255),
                  ),
                ),

                const Divider(
                  height: 24,
                  color: Colors.transparent,
                ),
                const Text('Telefon'),
                const Divider(
                  height: 6,
                  color: Colors.transparent,
                ),
                Text(
                  prefs.getString('phoneNumber').toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 62, 139, 255),
                  ),
                ),
                // TextInputField('********'),
                const Divider(
                  height: 24,
                  color: Colors.transparent,
                ),
                // MainButton(
                //     'Yadda saxla', Colors.black, Colors.black, Colors.white, () {})
              ],
            );
          },
        ),
      ),
    );
  }
}
