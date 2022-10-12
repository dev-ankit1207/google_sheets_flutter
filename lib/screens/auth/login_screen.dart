import 'package:flutter/material.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/screens/dashborad_screen.dart';
import 'package:invoice_maker/utils/common.dart';
import 'package:invoice_maker/utils/widgets/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      setStatusBarColor(transparentColor);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          cachedImage('https://www.desktopbackground.org/download/320x480/2014/01/21/704662_digital-art-simple-backgrounds-wallpapers-hd-desktop-and-mobile_1920x1080_h.png',
              fit: BoxFit.cover, height: context.height()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We have been expecting you !",
                style: boldTextStyle(size: 22, color: white),
              ),
              16.height,
              Text(
                'Neat and clean. Could not be better!',
                style: secondaryTextStyle(color: Colors.white70, size: 16),
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: 32),
              20.height,
              AppButton(
                width: context.width() - 80,
                shapeBorder: dialogShape(60),
                child: TextIcon(
                  spacing: 16,
                  textStyle: boldTextStyle(size: 18),
                  text: "Sign in with Google",
                  prefix: GoogleLogoWidget(size: 20),
                  onTap: null,
                ),
                onTap: () async {
                  appStore.setLoading(true);
                  await authService.signInWithGoogle().then((user) {
                    appStore.setLoading(false);

                    DashboardScreen().launch(context, isNewTask: true);
                  }).catchError((e) {
                    toast(e.toString());
                  }).whenComplete(() => appStore.setLoading(false));
                },
              ),
            ],
          ),
          loaderWidgetWithObserver(),
        ],
      ),
    );
  }
}
