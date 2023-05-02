import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String uuid = '';
  String resetUUid = '';
  String? _authToken = '';
  DateTime? _expiryDate;
  final String _name = '';
  final String _surname = '';
  final String _phoneNumber = '';
  bool get isAuth {
    return token != '';
  }

  String get name {
    return _name;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken;
    }
    return '';
  }

  Future<void> register(
    String firstName,
    String lastName,
    String password,
    int gender,
    String dateofBirth,
    String phone,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/users/signup');

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "phoneNumber": "994$phone"
        },
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          "email": "exampaaalea@mail.ru",
          'password': password,
          'gender': gender,
          'birthDate': dateofBirth,
        }),
      );
      print('$firstName, $lastName, $password, $gender, $phone, $dateofBirth');
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['code'] == 208) {
        throw ('Istifadeci artiq movcuddur');
      } else if (responseData['code'] != 200) {
        throw ('Gozlenilmeyen xeta bas verdi');
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> otp(
    String phone,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/otp/create');
    try {
      final response = await http.post(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: json.encode({
            'phoneNumber': '994$phone',
          }));
      final responseData = json.decode(response.body);
      uuid = responseData["response"]["uuid"] as String;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> checkOtp(
    String phone,
    String otpCode,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/otp/check');
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode(
          {
            'uuid': uuid,
            'otp': otpCode,
            'phoneNumber': '994$phone',
          },
        ),
      );

      print(uuid);

      final responseData = json.decode(response.body);
      final errorCode = responseData['status'];
      if (errorCode != null && errorCode != 200) {
        throw HttpException(responseData['error']);
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> login(
    String phone,
    String password,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/users/login');
    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode({
          'phoneNumber': '994$phone',
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      _authToken = responseData['response']['token'];
      _expiryDate = DateTime.now().add(const Duration(days: 365));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _authToken,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
      final userId = responseData['response']['user']['id'];
      prefs.setString('userId', userId.toString());

      prefs.setString('name', responseData['response']['user']['firstName']);
      prefs.setString('lastname', responseData['response']['user']['lastName']);
      prefs.setString(
          'phoneNumber', responseData['response']['user']['phoneNumber']);

      final responseMessage = responseData['message'];
      if (responseData['code'] != 200) {
        throw (responseMessage);
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');
      return false;
    } else {
      final extractedUserData =
          jsonDecode(prefs.getString('userData').toString())
              as Map<String, dynamic>;
      final expiryDate =
          DateTime.parse(extractedUserData['expiryDate'].toString());
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _authToken = extractedUserData['token'].toString();
      _expiryDate = expiryDate;
      notifyListeners();
      return true;
    }
  }

  void logout() async {
    _authToken = '';
    _expiryDate = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  Future<void> sendReport({
    dynamic latitude,
    dynamic longitude,
    String? description,
    List? images,
    File? video,
    File? voice,
  }) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/emergency-details/insert');

    List<http.MultipartFile> newList = [];

    try {
      final request = http.MultipartRequest("POST", url)
        ..headers.addAll(headers);

      if (voice != null) {
        var rvoice = http.MultipartFile(
          'voice',
          voice.openRead(),
          await voice.length(),
          filename: voice.path.toString(),
        );
        newList.add(rvoice);
      }
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('userId');

      print(uid);

      if (video != null) {
        var rvideo = http.MultipartFile(
          'multipartFiles',
          video.openRead(),
          await video.length(),
          filename: video.path.toString(),
        );
        newList.add(rvideo);
      }

      for (var i = 0; i < images!.length; i++) {
        if (images[i] != null) {
          var multipartfile = http.MultipartFile(
            'multipartFiles',
            images[i].openRead(),
            await images[i].length(),
            filename: images[i].path.split('/').last.split('-').last.toString(),
          );
          newList.add(multipartfile);
        } else {
          return;
        }
      }

      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['description'] = description!;
      request.files.addAll(newList);

      request.fields['idUser'] = uid.toString();
      print(uid);
      var response = await http.Response.fromStream(await request.send());
      final responseData = json.decode(response.body);
      print(responseData);

      final errorCode = responseData['code'];
      if (errorCode != 200) {
        throw HttpException(responseData['message']);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resetPassword(
    String phone,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/users/resetPassword');
    try {
      final response = await http.post(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: json.encode({
            'phoneNumber': '994$phone',
          }));
      final responseData = json.decode(response.body);
      print(responseData);

      resetUUid = responseData["response"]["uuid"] as String;
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> resetPasswordConfirm(
    String phone,
    String otpCode,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/users/resetPasswordConfirm');
    try {
      final response = await http.post(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: json.encode({
            'phoneNumber': '994$phone',
            'uuid': resetUUid,
            'otp': otpCode,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> changePassword(
    String phone,
    String password,
  ) async {
    final url = Uri.parse(
        'http://45.137.148.160:9023/mobile/volunteer-rescue-project/users/changePassword');
    try {
      final response = await http.put(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "phoneNumber": '994$phone'
          },
          body: json.encode({
            'password1': password,
            'passwordAgain1': password,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
    } catch (error) {
      throw HttpException(error.toString());
    }
  }
}
