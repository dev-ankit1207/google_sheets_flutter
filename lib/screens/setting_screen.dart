import 'package:flutter/material.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "Settings",
        showBack: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            32.height,
            circleAvatarWidget(image: appStore.userProfileImage.validate(), size: 124),
            32.height,
            Text('${appStore.userFullName.validate()}', style: boldTextStyle(size: 24)),
            8.height,
            Text('${appStore.userEmail.validate()}', style: primaryTextStyle(size: 20)),
            32.height,
            SettingItemWidget(
              title: 'Logout',
              trailing: Icon(Icons.logout),
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  primaryColor: redColor,
                  dialogAnimation: DialogAnimation.SCALE,
                  shape: RoundedRectangleBorder(borderRadius: radius(20)),
                  onAccept: (c) {
                    authService.logout(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
