import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/models/user_response.dart';
import 'package:invoice_maker/services/base_service.dart';

class UserService extends BaseService<UserModel> {
  UserService() {
    ref = fireStore.collection("users").withConverter<UserModel>(
          fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  Future<bool> isUserExist(String? email) async {
    Query query = ref!.limit(1).where('email', isEqualTo: email);
    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<UserModel> userByEmail(String? email) async {
    return ref!.limit(1).where('email', isEqualTo: email).get().then((value) => value.docs.first.data());
  }

  Future<UserModel> userByUid(String? uid) async {
    return ref!.limit(1).where('uid', isEqualTo: uid).get().then((value) => value.docs.first.data());
  }
}
