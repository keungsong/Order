import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/Login/login.dart';
import 'package:order/Provider/LocationProvider.dart';
import 'package:order/Provider/authProvider.dart';
import 'package:order/Screens/LoginScreen.dart';
import 'package:order/Screens/MapScreen.dart';
import 'package:order/Screens/home.dart';
import 'package:order/Screens/welcomScreen.dart';
import 'package:order/SplashScreen/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Home.id: (context) => Home(),
        WelcomScreen.id: (context) => WelcomScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen()
      },
    );
  }
}
