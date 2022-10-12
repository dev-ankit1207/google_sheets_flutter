import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:invoice_maker/screens/splash_screen.dart';
import 'package:invoice_maker/services/auth_services.dart';
import 'package:invoice_maker/services/gsheets_services.dart';
import 'package:invoice_maker/services/user_services.dart';
import 'package:invoice_maker/store/app_store.dart';
import 'package:invoice_maker/utils/configs.dart';
import 'package:invoice_maker/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;

UserService userService = UserService();
AuthService authService = AuthService();
AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initialize();

  /// Initialize the Google Work sheet.
  await GSheetsServices.initializeForWorksheet(spreadsheetId, worksheetTitle);
  appStore.setLoggedIn(getBoolAsync(SharePreferencesKey.IS_LOGGED_IN));

  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(SharePreferencesKey.USER_ID));
    appStore.setFullName(getStringAsync(SharePreferencesKey.USER_NAME));
    appStore.setUserEmail(getStringAsync(SharePreferencesKey.USER_EMAIL));
    appStore.setUserProfile(getStringAsync(SharePreferencesKey.USER_IMAGE));
    appStore.setAdmin(getBoolAsync(SharePreferencesKey.IS_ADMIN));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}
