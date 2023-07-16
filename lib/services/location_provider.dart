// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:upbox/services/auth.dart';

// class LocationProvider with ChangeNotifier {
//   Location? _location;
//   Location get location => _location!;

//   LatLng? _locationPosition;

//   LatLng get locationPosition =>
//       _locationPosition ?? const LatLng(0.347596, 32.582520);

//   bool locationServiceActive = true;

//   LocationProvider() {
//     _location = Location();
//   }

//   initialization() async {
//     await getUserLocation();
//   }

//   getUserLocation() async {
//     try {
//       bool serviceEnabled;
//       PermissionStatus permissionGranted;

//       serviceEnabled = await location.serviceEnabled();

//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();

//         if (!serviceEnabled) {
//           return;
//         }
//       }

//       permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           return;
//         }
//       }

//       location.onLocationChanged.listen((LocationData currentLocation) {
//         _locationPosition = LatLng(
//           currentLocation.latitude!,
//           currentLocation.longitude!,
//         );

//         // ignore: avoid_print
//         // print(_locationPosition);
//         _locationPosition!.latitude;
//         _locationPosition!.longitude;

//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(Auth().currentUser!.uid)
//             .update({
//           "user_lat": _locationPosition!.latitude,
//           "user_lng": _locationPosition!.longitude,
//         });
//         notifyListeners();
//       });
//     } catch (e) {
//       return e;
//     }
//   }
// }
