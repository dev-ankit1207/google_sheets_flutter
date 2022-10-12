import 'package:flutter/material.dart';
import 'package:invoice_maker/models/save_data.dart';
import 'package:invoice_maker/screens/add_user_detail_screen.dart';
import 'package:invoice_maker/screens/setting_screen.dart';
import 'package:invoice_maker/services/gsheets_services.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(Colors.white);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast("Press back again to exit app");
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appBarWidget(
          "Dashboard",
          showBack: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                SettingScreen().launch(context);
              },
              icon: Icon(Icons.settings, color: black),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AddUserDetailsScreen().launch(context).then((value) => setState(() {}));
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            return await 2.seconds.delay;
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Testing sheets', style: boldTextStyle(size: 22)),
                4.height,
                Text('This are the data from the Google sheets', style: secondaryTextStyle(size: 16)),
                32.height,
                FutureBuilder<List<SaveData>>(
                  future: GSheetsServices.getEntries(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snap.data!.length,
                          padding: EdgeInsets.only(bottom: 60),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            SaveData value = snap.data![index];
                            return Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: boxDecorationDefault(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('First Name', style: secondaryTextStyle()).expand(),
                                      Text(value.firstName.validate(), style: boldTextStyle()),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Text('Last Name', style: secondaryTextStyle()).expand(),
                                      Text(value.lastName.validate(), style: boldTextStyle()),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Text('User Name', style: secondaryTextStyle()).expand(),
                                      Text(value.userName.validate(), style: boldTextStyle()),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Text('Age Name', style: secondaryTextStyle()).expand(),
                                      Text(value.age.validate(), style: boldTextStyle()),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      Text('Gender Name', style: secondaryTextStyle()).expand(),
                                      Text(value.gender.validate(), style: boldTextStyle()),
                                    ],
                                  ),
                                  16.height,
                                  TextButton(
                                    onPressed: () {
                                      showConfirmDialogCustom(
                                        context,
                                        dialogType: DialogType.DELETE,
                                        dialogAnimation: DialogAnimation.SCALE,
                                        onAccept: (c) {
                                          GSheetsServices.deleteEntry(index);
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: Text('Delete'.toUpperCase(), style: secondaryTextStyle(color: redColor)),
                                  ).center()
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Text('No Data found', style: boldTextStyle()).center();
                      }
                    }
                    return snapWidgetHelper(snap);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
