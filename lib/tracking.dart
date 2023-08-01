import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
// final User? user = Auth().currentUser;

//   GeoPoint? dGeo;
//   driverGeo() async {
//     FirebaseFirestore.instance
//         .collection('drivers')
//         .where("id", isEqualTo: user!.uid )
//         .get()
//         .then((value) {
//       dGeo = value.docs[0]['driverLocation'];
//       // print("driver latitude: ${dGeo!.latitude}");
//       // print("driver longitude: ${dGeo!.longitude}");
//     });
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
              child: Text(
            'Tracking ',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          )),
        ),
        body: GoogleMap(
          trafficEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          compassEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.3162800, 32.5821900),
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
