import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'menu_screen.dart';
import 'report_screen.dart';

const map = 'assets/image7.png';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    print(_currentPosition);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _askPermission() async {
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mikrofona icaze verilmedi'),
      ));
      openAppSettings();
    }
  }

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        // leading: const Icon(Icons.notification_important_outlined),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          GestureDetector(
            onTap: (() {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MenuScreen()));
            }),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                'assets/profile.svg',
                fit: BoxFit.contain,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(bottom: 176),
              child: const GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.3946, 49.8494),
                  zoom: 15.0,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 176,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReportScreen(
                                    _currentPosition!.latitude.toString(),
                                    _currentPosition!.longitude.toString(),
                                  )));
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(44),
                              color: const Color(0XFF1890FF)),
                          width: 88,
                          height: 88,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Xəbər et',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
