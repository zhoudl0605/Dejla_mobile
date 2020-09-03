import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dejla/services/Profile.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AvatarCapture extends StatefulWidget {
  AvatarCapture({Key key, this.callback}) : super(key: key);
  final callback;

  @override
  _AvatarCaptureState createState() => _AvatarCaptureState();
}

class _AvatarCaptureState extends State<AvatarCapture> {
  File _imageFile;
  String _imgURL =
      "https://firebasestorage.googleapis.com/v0/b/dejla-4c075.appspot.com/o/system%2Fround-add-button.png?alt=media&token=02b895fd-ec50-42be-acfb-7eeb4624aabb";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProfileAvatar(
        _imgURL, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
        radius: 50, // sets radius, default 50.0
        elevation:
            5.0, // sets elevation (shadow of the profile picture), default value is 0.0
        cacheImage: true, // allow widget to cache image against provided url
        onTap: () {
          Alert(
            context: context,
            type: AlertType.info,
            title: "Choose your avatar",
            desc:
                "Pleas take a new photot or select one from your existing photo library.",
            buttons: [
              DialogButton(
                child: Text(
                  "Camera",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
              DialogButton(
                child: Text(
                  "Library",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                color: Colors.redAccent,
              )
            ],
          ).show();
        }, // sets on tap
        showInitialTextAbovePicture:
            true, // setting it true will show initials text above profile picture, default false
      ),
    );
  }

  // Select image from camera or library
  Future _pickImage(ImageSource source) async {
    File select = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = select;
    });

    if (_imageFile != null) _cropImage();
  }

  // Crop image
  Future _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        maxHeight: 500,
        maxWidth: 500,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          // toolbarColor: Color(0xff0f4c81),
          // toolbarWidgetColor: Color(0xfff0ece3),
          lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: true,
        ));
    //TODO: compress image
    if (cropped == null) {
      _imageFile = _imageFile;
      // widget.callback(_imageFile);
    } else {
      _imageFile = cropped;
      // widget.callback(_imageFile);
      var _url = await ProfileService().uploadAvatar(_imageFile);
      if (_url != null) {
        setState(() {
          _imgURL = _url;
        });
      }
    }
  }
}
