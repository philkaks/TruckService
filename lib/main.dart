import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/maps_screen.dart';


Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await dotenv.load(fileName: '.env');
  await Future.delayed(const Duration(seconds: 3));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: "Work_Sans",
        brightness: Brightness.light,
      ),
      home: const MainScreen(
        sourceLocationName: 'kampala',
        destinationName: 'gulu',
        cNAme: 'Uganda',
        // sName: '',
      ),
      // AdminPage(),
      //  Driver(),
      // LoginPage(),
      // AppStart(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
// ? test if the API works.
// https://maps.googleapis.com/maps/api/directions/json?origin=kampala&destination=gulu&key=AIzaSyAAdIxyR8uIlf95cQvjONiX2f3U6IUBUpk