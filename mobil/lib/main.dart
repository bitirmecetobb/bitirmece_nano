import 'package:bitirmece_test/backend/resultInfoService.dart';
import 'package:bitirmece_test/screens/results/resultsPage.dart';
import 'package:bitirmece_test/screens/signIn/signInPage.dart';
import 'package:bitirmece_test/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA7_2rR8cQlsYVsXEuJ_WXUHCa4a79kPiI",
            appId: "1:874593886568:android:8f52ee74e61d80b7f836dd",
            messagingSenderId: "874593886568",
            projectId: "bitirmece-74b65"));
  }


  CurrentAppTheme = AppTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    bool isSignedIn = false;
    final currentUser = _auth.currentUser;
    if(currentUser != null){
      isSignedIn = true;
      userGlobalService = ResultInfoService(userUid: currentUser.uid);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isSignedIn ? ResultsPage() : SignInPage(),
    );
  }
}
