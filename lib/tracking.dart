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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Tracking ')),
      ),
      body: GoogleMap(
      trafficEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      compassEnabled: false,
      mapType: MapType.normal,
      // markers: {},
      // markers: (_locationData == null)
      //     ? {}
      //     : {
      //         Marker(
      //           markerId: const MarkerId('m1'),
      //           position: LatLng(
      //             _locationData!.latitude!,
      //             _locationData!.longitude!,
      //           ),
      //         ),
      //       },
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    )
    );
  }
}