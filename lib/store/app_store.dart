import 'package:invoice_maker/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isLoading = false;
  @observable
  bool isAdmin = false;

  @observable
  String userProfileImage = '';

  @observable
  String userFullName = '';

  @observable
  String userEmail = '';

  @observable
  String userId = '';

  @action
  Future<bool> setLoading(bool val) async {
    return isLoading = val;
  }

  @observable
  bool isLoggedIn = false;

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (isInitializing) setValue(SharePreferencesKey.IS_LOGGED_IN, val.validate());
  }

  @action
  void setUserId(String val, {bool isInitializing = false}) {
    userId = val;
    if (isInitializing) setValue(SharePreferencesKey.USER_ID, val.validate());
  }

  @action
  void setUserEmail(String val, {bool isInitializing = false}) {
    userEmail = val;
    if (isInitializing) setValue(SharePreferencesKey.USER_EMAIL, val.validate());
  }

  @action
  void setFullName(String val, {bool isInitializing = false}) {
    userFullName = val;
    if (isInitializing) setValue(SharePreferencesKey.USER_NAME, val.validate());
  }

  @action
  void setUserProfile(String image, {bool isInitializing = false}) {
    userProfileImage = image;
    if (isInitializing) setValue(SharePreferencesKey.USER_IMAGE, image.validate());
  }

  @action
  void setAdmin(bool value, {bool isInitializing = false}) {
    isAdmin = value;
    if (isInitializing) setValue(SharePreferencesKey.IS_ADMIN, value.validate());
  }
}
