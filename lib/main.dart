import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'tracking.dart';
import 'pages/maps_screen.dart';
import 'services/widget_tree.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: "Work_Sans",
          brightness: Brightness.light,
        ),
        home: const
            // AdminPage(),
            // Driver(),
            // HomePage(),
            // MapScreen(),
            // MainScreen(sourceLocationName: 'kampala', destinationName: 'entebbe', ),

            WidgetTree(),
            // OrderScreen(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
    // MultiProvider(
    // providers: [
    // ChangeNotifierProvider(
    //   create: (context) => LocationProvider(),
    //   child: const AppStart(),
    // ),

    // ChangeNotifierProvider(
    //   create: (context) => GoogleSignInProvider(),
    //   child: const LoginPage(),
    // )
    // ],
    //   child:
    // );
  }
}







// TODO: THESE CHANGES BELOW SUGGESTED BY THE CLIENT SHOULD BE IMPLEMENTED.
// ?completed
// pending



// the map should focus on the point of focus.
//? the suggestion should be brought up when the user is typing.

//? CALCULATE THE VALUE OF THE RIDE PER KILOMETER.
//? consider the nature of the goods.

//? small sized truck
//? large
//? medium
//? this determines price per kilometer.
//? Add map to the drivers section

// the driver should be able to see the map and the location of the user. and vice versa.
// THE DRIVER SHOULD HAVE THE TYPE OF TRUCK HE HAS PUSHED TO THE DATABASE.
// update the location of user and driver to the database.


//? order for a truck.


// get notification when the truck is on the way.
// get notification when the truck is at the pickup location.
// get notification when the truck is at the drop off location.
//! get notification to the driver when he is assigned a job.

// calculate the distance between the driver and user.

// COLOR SCHEME
// Colors blue and white.

//? put a home screen for the user, but not to come to the map directly.
//? e.g order a truck, track a truck, contact us, about us, terms and conditions, privacy policy, etc.

// ? admin UI
// ? should be able to see all the drivers and their details. plus users and their details.
// ? should be able to see all the orders and their details.
// ? CRUD operations on the admin side.

