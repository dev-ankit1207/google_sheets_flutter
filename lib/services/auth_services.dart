import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/models/user_response.dart';
import 'package:invoice_maker/screens/auth/login_screen.dart';
import 'package:invoice_maker/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

class AuthService {
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn().catchError((e) {
      log(e.toString());
    });

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);
      await googleSignIn.signOut();

      await loginFromFirebaseUser(user);
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> updateUserData(UserModel user) async {
    userService.updateDocument({
      'updatedAt': Timestamp.now(),
    }, user.uid.validate());
  }

  Future<void> loginFromFirebaseUser(User currentUser, {String? fullName}) async {
    UserModel userModel = UserModel();

    if (await userService.isUserExist(currentUser.email)) {
      ///Return user data
      await userService.userByEmail(currentUser.email).then((user) async {
        userModel = user;

        await updateUserData(user);
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      /// Create user
      userModel.email = currentUser.email;
      userModel.phoneNumber = currentUser.phoneNumber.toInt();
      userModel.uid = currentUser.uid;
      userModel.image = currentUser.photoURL;
      userModel.isAdmin = false;
      userModel.isEmailLogin = false;
      userModel.createdAt = Timestamp.now();
      userModel.updatedAt = Timestamp.now();
      if (isIOS) {
        userModel.name = fullName;
      } else {
        userModel.name = currentUser.displayName.validate();
      }

      await userService.addDocumentWithCustomId(currentUser.uid, userModel).then((value) {}).catchError((e) {
        throw e;
      });
    }

    await setUserDetailPreference(userModel);
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    appStore.setLoggedIn(true, isInitializing: true);

    appStore.setFullName(user.name.validate(), isInitializing: true);
    appStore.setUserEmail(user.email.validate(), isInitializing: true);
    appStore.setUserProfile(user.image.validate(), isInitializing: true);
    appStore.setUserId(user.uid.validate(), isInitializing: true);
    appStore.setAdmin(user.isAdmin.validate(), isInitializing: true);

    setValue(SharePreferencesKey.IS_EMAIL_LOGIN, user.isEmailLogin.validate());
  }

  Future<void> logout(BuildContext context) async {
    appStore.setLoggedIn(false, isInitializing: true);

    appStore.setFullName('', isInitializing: true);
    appStore.setUserEmail('', isInitializing: true);
    appStore.setUserProfile('', isInitializing: true);
    appStore.setUserId('', isInitializing: true);
    appStore.setAdmin(false, isInitializing: true);

    removeKey(SharePreferencesKey.IS_EMAIL_LOGIN);

    LoginScreen().launch(context, isNewTask: true);
  }
}
