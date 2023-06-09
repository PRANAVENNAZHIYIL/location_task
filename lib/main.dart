import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googlemap_latlon/screens/home_screen.dart';
import 'package:googlemap_latlon/screens/signin_screen.dart';
import 'package:googlemap_latlon/service/notification_service.dart';

import 'helper/helperfunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: const Color(0xFFee7b64),
            scaffoldBackgroundColor: Colors.white),
        home: _isSignedIn ? const HomeScreen() : const LoginPage());
    //   home: const HomeScreen(),
    // );
  }
}
