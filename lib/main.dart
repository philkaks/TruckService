
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:upbox/pages/app_start.dart';
import 'package:upbox/services/location_provider.dart';

import 'services/widget_tree.dart';

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
  // await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const AppStart(),
        ),

        // ChangeNotifierProvider(
        //   create: (context) => GoogleSignInProvider(),
        //   child: const LoginPage(),
        // )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: "Work_Sans",
          brightness: Brightness.light,
        ),
        home: const 
        // AdminPage(),
        // Driver(),
        
        WidgetTree(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


// the map should focus on the point of focus.
// the suggestion should be brought up when the user is typing.


// CALCULATE THE VALUE OF THE RIDE PER KILOMETER.
// consider the nature of the goods.


// small sized truck
// large
// medium
// this determines price per kilometer.
// THE DRIVER SHOULD HAVE THE TYPE OF TRUCK HE HAS PUSHED TO THE DATABASE.



// Add map to the drivers section

// order for a truck.

// get notification when the truck is on the way.
// get notification when the truck is at the pickup location.
// get notification when the truck is at the drop off location.
//! get notification to the driver when he is assigned a job.


// calculate the distance between the driver and user.

// COLOR SCHEME
// Colors blue and white. 



// put a home screen for the user, but not to come to the map directly.
// e.g order a truck, track a truck, contact us, about us, terms and conditions, privacy policy, etc.



// admin UI
// should be able to see all the drivers and their details. plus users and their details.
// should be able to see all the orders and their details.


