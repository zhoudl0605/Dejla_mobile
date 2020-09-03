import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dejla/modules/UserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Auth.dart';
import 'package:flutter/widgets.dart';

class ProfileService with ChangeNotifier {
  FirebaseUser _user;
  bool hasProfile;
  
  StreamSubscription _subscription;
  StreamSubscription _userSubscription;
  UserProfile profile;

  ProfileService() {
    _userSubscription = authService.user.listen((data) {
      _user = data;
      if (_user != null) getUserProfile();
      notifyListeners();
    });
  }

  // set user avatar folder bucket
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://dejla-4c075.appspot.com');

  // set the collection
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  // upload user avatar
  Future uploadAvatar(File file) async {
    try {
      if (file != null) {
        String path = '/user_profile/${_user.uid}/avatar/${DateTime.now()}.png';
        StorageReference storageReference = _storage.ref().child(path);
        StorageUploadTask uploadTask = storageReference.putFile(file);
        await uploadTask.onComplete;
        print('File Uploaded');
        var fileURL = await storageReference.getDownloadURL();

        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.photoUrl = fileURL;
        await _user.updateProfile(userUpdateInfo);
        await authService.reloadFirebaseUser();
        return fileURL;
      }
      return;
    } catch (err) {
      print(err.message);
      return;
    }
  }

  getUserProfile() {
    _subscription = userCollection
        .document(_user.uid)
        .snapshots()
        .listen((DocumentSnapshot doc) {
      doc == null
          ? profile = null
          : profile = UserProfile(
              dateOfBirth: doc['dateOfBirth'],
              favorite: doc['favorite'],
            );
      notifyListeners();
    });
  }

  removeFavorite(data) {
    userCollection.document(_user.uid).updateData({
      "favorite": FieldValue.arrayRemove([data])
    });
  }

  addFavorite(data) {
    userCollection.document(_user.uid).updateData({
      "favorite": FieldValue.arrayUnion([data])
    });
  }

  // update user name in the profile
  Future addUserName(String name) async {
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await _user.updateProfile(userUpdateInfo);
    await authService.reloadFirebaseUser();
  }

  Future addUserDateOfBirth(DateTime date) async {
    DocumentReference path =
        Firestore.instance.collection('users').document(_user.uid);

    return await path.updateData(
      {'date_of_birth': date},
    );
  }

  // Logout
  clear() {
    if (_subscription != null) _subscription.cancel();
    if (_userSubscription != null) _userSubscription.cancel();
    profile = null;
  }
}

ProfileService profileService = new ProfileService();
