import 'package:flutter/material.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/screens/auth/login_screen.dart';
import 'package:invoice_maker/screens/dashborad_screen.dart';
import 'package:invoice_maker/utils/constants.dart';
import 'package:invoice_maker/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    3.seconds.delay.then((value) {
      if (appStore.isLoggedIn) {
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        LoginScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(appLogo, height: 120, width: 120),
            16.height,
            Text(appName, style: boldTextStyle(size: 20)),
          ],
        ),
      ),
    );
  }
}
