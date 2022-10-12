import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice_maker/main.dart';
import 'package:nb_utils/nb_utils.dart';

abstract class BaseService<T> {
  CollectionReference<T>? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(T data) async {
    var doc = await ref!.add(data);
    doc.update({'uid': doc.id});
    return doc;
  }

  Future<DocumentReference> addDocumentWithCustomId(String id, T data) async {
    var doc = ref!.doc(id);

    return await doc.set(data).then((value) {
      return doc;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) => ref!.doc(id).update(data);

  Future<void> removeDocument(String id) => ref!.doc(id).delete();

  Future<bool> isUserExist(String? email) async {
    Query query = ref!.limit(1).where('email', isEqualTo: email);
    var res = await query.get();

    if (res.docs.isNotEmpty) {
      return res.docs.length == 1;
    } else {
      return false;
    }
  }

  Future<Iterable> getList() async {
    var res = await ref!.get();
    Iterable it = res.docs;
    return it;
  }

  static Future<String> getUploadedImageURL(XFile image, String path, {Function(int)? onProgress}) async {
    Reference storageRef = storage.ref().child(path);
    UploadTask? uploadTask;

    if (isWeb) {
      Uint8List bytes = await image.readAsBytes();
      uploadTask = storageRef.putData(bytes);
    } else {
      uploadTask = storageRef.putFile(File(image.path));
    }

    uploadTask.snapshotEvents.listen((element) {
      log("bytesTransferred ${element.bytesTransferred}");
      log("totalBytes ${element.totalBytes}");

      log("${image.name} percentage ${element.bytesTransferred * 100 / element.totalBytes}");
      onProgress?.call(element.bytesTransferred * 100 ~/ element.totalBytes);
    });

    return await uploadTask.then((e) async {
      return await e.ref.getDownloadURL().then((value) {
        return value;
      });
    });
  }
}
