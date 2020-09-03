import 'package:dejla/services/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCredential credential;
  String _verificationId;

  // auth change user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // Email login
  Future emailSignIn(email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      profileService = new ProfileService();

      return result.user;
    } catch (err) {
      print(err.toString());
      return err;
    }
  }

  // Sign Out
  Future signOut() async {
    profileService.clear();
    _verificationId = '';
    credential = null;
    return await _auth.signOut();
  }

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future<FirebaseUser> getCurrentUser() async {
    await reloadFirebaseUser();
    return await _auth.currentUser();
  }

  // send verification email
  Future sendVerificationEmail() async {
    try {
      FirebaseUser _result = await getCurrentUser();
      return _result.sendEmailVerification();
    } catch (err) {
      print(err.toString());
    }
  }

  // refresh Firebase User
  Future reloadFirebaseUser() async {
    if ((await _auth.currentUser()) == null) return;
    (await _auth.currentUser()).reload();
    // print((await _auth.currentUser()).isEmailVerified);
  }

  // Send email to Firebase User to reset password
  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  getFirebaseUserInstance() {
    return _auth;
  }

  // Phone verify
  Future phoneNumberVerify(String phone) async {
    final PhoneCodeSent _codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print('Code sent to $phone');
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout =
        (String verificationId) {
      print("\nAuto retrieval time out");
      _verificationId = verificationId;
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      var status = '${authException.message}';
      print("Error message: " + status);

      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      else
        status = 'Something has gone wrong, please try later';

      print(status);
      _verificationId = "";
      return authException;
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      _auth.signInWithCredential(auth).then((AuthResult value) {
        if (value.user != null) {
          print('Authentication successful');
          profileService = new ProfileService();
        } else {
          print('Invalid code/invalid authentication');
        }
      }).catchError((error) {
        print('Something has gone wrong, please try later ${error.toString()}');
      });
    };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 10),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: _codeSent,
          codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
    } catch (err) {
      print("haha: " + err.message.toString());
      return err;
    }
  }

  Future phoneNumberSignIn(String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
    } catch (err) {
      print(err.message);
      return err.message;
    }
  }

  setUserEmail(String email) async {
    try {
      await (await (_auth.currentUser())).updateEmail(email);
      return null;
    } catch (err) {
      print(err.message);
      return err;
    }
  }

  setUserPassword(String password) async {
    try {
      await (await (_auth.currentUser())).updatePassword(password);
      return null;
    } catch (err) {
      print(err.message);
      return err;
    }
  }
}

final authService = AuthService();
