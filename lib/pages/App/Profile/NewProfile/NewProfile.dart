import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dejla/services/Auth.dart';
import 'package:dejla/services/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProfilePage extends StatefulWidget {
  NewProfilePage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<NewProfilePage> {
  // Form data
  var showalert = false;
  String firstName = "";
  String middleName = "";
  String lastName = "";
  final _formKey = GlobalKey<FormState>();
  File _imageFile;
  String fileURL;
  DateTime date;

  // Textfield focus node
  FocusNode nodeOne = new FocusNode();
  FocusNode nodeTwo = new FocusNode();

  @override
  void dispose() {
    nodeOne.dispose();
    nodeTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    AuthService auth = Provider.of<AuthService>(context);
    ProfileService profile = Provider.of<ProfileService>(context);

    return Scaffold(
      body: GFFloatingWidget(
        verticalPosition: MediaQuery.of(context).size.height / 3,
        showblurness: showalert,
        child: showalert == false
            ? Container()
            : GFAlert(
                title: 'Choose your photo',
                content:
                    "Pleas take a new photot or select one from your existing photo library.",
                bottombar: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GFButton(
                      onPressed: () {
                        setState(() {
                          showalert = false;
                        });
                        _pickImage(ImageSource.camera);
                      },
                      text: "Camera",
                      icon: Icon(
                        Icons.photo_camera,
                        color: GFColors.WHITE,
                      ),
                    ),
                    SizedBox(width: 5),
                    GFButton(
                      onPressed: () {
                        setState(() {
                          showalert = false;
                        });
                        _pickImage(ImageSource.gallery);
                      },
                      icon: Icon(
                        Icons.photo_library,
                        color: GFColors.WHITE,
                      ),
                      text: 'Library',
                    )
                  ],
                ),
              ),
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: GFColors.WHITE,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "New Profile",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              GFButton(
                text: "Skip",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: GFColors.WHITE,
                textColor: GFColors.PRIMARY,
                size: GFSize.LARGE,
              )
            ],
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StreamBuilder(
                      stream: auth.user,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        FirebaseUser user = snapshot.data;
                        if (user == null) return Container();
                        String url;
                        if (user.photoUrl == null && fileURL == null)
                          url = "";
                        else if (user.photoUrl == null && fileURL != null)
                          url = fileURL;
                        else if (user.photoUrl != null && fileURL == null)
                          url = user.photoUrl;
                        else
                          url = fileURL;

                        return GFAvatar(
                          shape: GFAvatarShape.circle,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              imageUrl: url,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.person_outline),
                            ),
                          ),
                          size: 50.0,
                        );
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: auth.user,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      FirebaseUser user = snapshot.data;
                      if (user == null) return Container();

                      String name = user.displayName;
                      return Text(
                        name == null ? "Dear user" : name,
                        style: textTheme.headline,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "You're almost there! Please complete the remaining steps below. " +
                          " Or you can click the button on the top right corner to skip and complete in the future",
                      textAlign: TextAlign.center,
                      style: textTheme.caption,
                    ),
                  ),
                  GFButton(
                    onPressed: () {
                      setState(() {
                        showalert = !showalert;
                      });
                    },
                    type: GFButtonType.outline,
                    size: GFSize.LARGE,
                    text: "Choose a photo for yourself",
                  ),
                  SizedBox(height: 10),
                  GFButton(
                    onPressed: () async {
                      DateTime date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            (DateTime.now().subtract(Duration(days: 45000))),
                        lastDate: DateTime.now(),
                      );
                      setState(() {
                        this.date = date;
                      });
                    },
                    type: GFButtonType.outline,
                    size: GFSize.LARGE,
                    text: date != null
                        ? "${date.year}/${date.month}/${date.day}"
                        : "Choose your birthday",
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "First name",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(nodeOne);
                    },
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onChanged: (String val) {
                      setState(() {
                        firstName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: nodeOne,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Middle name",
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(nodeTwo);
                    },
                    maxLines: 1,
                    validator: (value) {
                      return null;
                    },
                    onChanged: (String val) {
                      setState(() {
                        middleName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: nodeTwo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Last name",
                    ),
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onChanged: (String val) {
                      setState(() {
                        lastName = val;
                      });
                    },
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(nodeTwo);
                    },
                  ),
                  SizedBox(height: 10),
                  GFButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid
                        String name;
                        if (middleName != null)
                          name = '$firstName $middleName $lastName';
                        else
                          name = '$firstName $lastName';

                        await profile.addUserName(name);
                        await profile.addUserDateOfBirth(date);
                        // If update success
                        Navigator.of(context).pop();
                      }
                    },
                    size: GFSize.LARGE,
                    text: "Submit",
                  ),
                ],
              ),
            ),
          ),
        ),
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
      var url = await ProfileService().uploadAvatar(_imageFile);
      setState(() {
        fileURL = url;
      });
    }
  }
}
