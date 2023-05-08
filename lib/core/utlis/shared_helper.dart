import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;
  return loggedIn;
}
