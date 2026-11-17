import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String validUsername = '124240081'; //usr pake NIM 
  static const String validPassword = '123'; //pw sesuai soal       

  //key untuk penyimpanan SharedPreferences
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUsername = 'username';

  //validasi kredensial login dan simpan sesi jika valid
  static Future<bool> login(String inputUsername, String inputPassword) async {
    if (inputUsername.trim() == validUsername && inputPassword.trim() == validPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setString(keyUsername, inputUsername.trim());
      return true;
    }
    return false;
  }

  //cek sesi login aktif sebelumnya
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  //ambil username tersimpan dari SharedPreferences
  static Future<String> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername) ?? validUsername;
  }

  //logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLoggedIn);
    await prefs.remove(keyUsername);
    // alternatif jika ingin menghapus seluruh data prefs menggunakan:
    // await prefs.clear();
  }
}