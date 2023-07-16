import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/order-selection/order_type.dart';
import 'package:upbox/utils/app_drawer.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static LatLng sourceLocation = const LatLng(9.0301, 7.4677);
  // static LatLng destination = const LatLng(9.0398, 7.5044);

  final LatLng _initialcameraposition = const LatLng(9.0765, 7.3986);
  LocationData? _locationData;
  final Location _location = Location();

  // final Location _location = Location();
  Future<void> _getCurrentLocation() async {
    try {
      final locData = await _location.getLocation();
      setState(() {
        _locationData = locData;
      });
      if (_locationData != null) {
        final controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                _locationData!.latitude!,
                _locationData!.longitude!,
              ),
              zoom: 14,
            ),
          ),
        );
      }
    } catch (error) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.menu),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 35),
        elevation: 0,
        bottomOpacity: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Center(child: googleMapUI()),
                );
              },
            ),
            DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.4,
              // maxChildSize: 0.7,
              // minChildSize: 0.4,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(15, 0, 0, 0),
                        blurRadius: 12,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            "images/deliver.png",
                            width: 142,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Center(
                          child: Text(
                            "Deliver item(s)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Center(
                          child: Text(
                            "Order a truck near you",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 129, 128, 128),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: const OrderType(),
                                  childCurrent: widget,
                                  type: PageTransitionType.fade,
                                  duration: const Duration(seconds: 0),
                                  reverseDuration: const Duration(seconds: 0),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(14),
                              ),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(
                                      color: Colors.transparent),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Order a truck",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget googleMapUI() {
    return GoogleMap(
      trafficEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      compassEnabled: false,
      mapType: MapType.normal,
      markers: (_locationData == null)
          ? {}
          : {
              Marker(
                markerId: const MarkerId('m1'),
                position: LatLng(
                  _locationData!.latitude!,
                  _locationData!.longitude!,
                ),
              ),
            },
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
