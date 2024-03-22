// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend/resultInfoService.dart';
import '../../theme.dart';
import '../loading.dart';
import '../results/resultsPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final _formStateKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  var email, password;
  String errorMessage = "";
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController mailTextController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: GestureDetector(
              onTap: () {
                _auth.signOut();
              },
              child: Container(
                  margin: EdgeInsets.all(CurrentAppTheme.height * 0.05),
                  height: CurrentAppTheme.height * 0.2,
                  child: Center(
                    child: Text(
                      "Bitirmece",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Form(
              key: _formStateKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    emailField(),
                    SizedBox(height: 20),
                    passwordField(),
                    SizedBox(height: 10),
                    errorMessageText(),
                    loginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row loginButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  elevation: MaterialStateProperty.all<double>(8.0),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  email = mailTextController.text;
                  password = passwordTextController.text;
                  if (_formStateKey.currentState!.validate()) {
                    _auth = FirebaseAuth.instance;
                    List<String> user =
                        await _auth.fetchSignInMethodsForEmail(email);

                    if (user.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingPage()));
                      try {
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        User? currentUser = _auth.currentUser;

                        if (null != currentUser) {
                          print("GİRİŞ YAPILDI");
                          userGlobalService =
                              ResultInfoService(userUid: currentUser.uid);
                          userGlobalService.changeActiveUser(currentUser.uid);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultsPage()),
                              (route) => false);
                        } else {
                          _auth.signOut();
                          errorMessage = "Şifreniz yanlış.";
                          Fluttertoast.showToast(msg: errorMessage);
                          Navigator.pop(context);
                          //wrong password
                        }
                      } catch (e) {
                        _auth.signOut();
                        errorMessage = "Şifreniz yanlış.";
                        Fluttertoast.showToast(msg: errorMessage);
                        Navigator.pop(context);
                      }
                    } else {
                      //create new account
                      Fluttertoast.showToast(msg: "HESABINIZ OLUŞTURULUYOR");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingPage()));

                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);

                      User? user = userCredential.user;

                      if (user != null) {
                        userGlobalService =
                            ResultInfoService(userUid: user.uid);
                        await userGlobalService.initializeResultInfo();
                        userGlobalService.changeActiveUser(user.uid);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsPage()),
                            (route) => false);
                      }
                    }
                  }
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding errorMessageText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(errorMessage,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
    );
  }

  Padding passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: passwordTextController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Padding emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        controller: mailTextController,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          fillColor: Colors.grey,
          hintText: "E mail",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
