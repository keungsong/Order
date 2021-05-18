import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:order/Localization/localization.dart';
import 'package:order/Providers/auth_provider.dart';
import 'package:order/Providers/location_provider.dart';
import 'package:order/Providers/store_provider.dart';

import 'package:order/Screens/home.dart';
import 'package:order/Screens/landing_screen.dart';
import 'package:order/Screens/login_screen.dart';
import 'package:order/Screens/main_screen.dart';
import 'package:order/Screens/map_screen.dart';
import 'package:order/Screens/register_screen.dart';
import 'package:order/Screens/vendor_home_screen.dart';
import 'package:order/Screens/welcom_screen.dart';

import 'package:order/SplashScreen/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => StoreProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
      locale: _locale,
      supportedLocales: [Locale('zh', 'LA'), Locale('en', 'US')],
      localizationsDelegates: [
        DemoLocalization.delegate,
        //GlobalMaterialLocalizations.delegate,
        //GlobalWidgetsLocalizations.delegate,
        //GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        Home.id: (context) => Home(),
        SplashScreen.id: (context) => SplashScreen(),
        WelcomScreen.id: (context) => WelcomScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
      },
    );
  }
}
