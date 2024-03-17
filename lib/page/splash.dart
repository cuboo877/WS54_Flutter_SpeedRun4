import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun4/page/home.dart';
import 'package:ws54_flutter_speedrun4/page/login.dart';
import 'package:ws54_flutter_speedrun4/service/auth.dart';
import 'package:ws54_flutter_speedrun4/service/sharedPref.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void delayNav() async {
    await Future.delayed(const Duration(microseconds: 250));
    String userID = await sharedPref.getLoggedUserID();
    if (userID.isNotEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(userID: userID)));
        print("dgot logged userID : ${userID}");
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            (MaterialPageRoute(builder: (context) => const LoginPage())));
        print("didnt get any logged userID");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/icon.png",
        width: 200,
        height: 200,
      ),
    );
  }
}
