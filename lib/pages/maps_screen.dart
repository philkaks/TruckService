// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upbox/providers.dart';
import 'package:upbox/services/local_notification_service.dart';
import 'package:upbox/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerStatefulWidget {
  final String sourceLocationName;
  final String destinationName;
  final String cNAme;
  final String sName;
  const MainScreen({
    super.key,
    required this.sourceLocationName,
    required this.destinationName,
    required this.cNAme,
    required this.sName,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var dName;
  var dPlate;
  var dRating;
  var dNumber;
  var dArrived;
  var dRides;
  var dId;

  // ! remove the static state and pass in the state from the api
  getData(String state) async {
    FirebaseFirestore.instance
        .collection('drivers')
        .where("driver_free", isEqualTo: true)
        .where("state", isEqualTo: 'kampala')
        .where("phoneNumberVerification", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: "No driver found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 199, 199, 199),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        dName = value.docs[0]['name'];
        dPlate = value.docs[0]['plateno'];
        dRating = value.docs[0]['rating'];
        dNumber = value.docs[0]['number'];
        dArrived = value.docs[0]['driver_arrived'];
        dRides = value.docs[0]['trips'];
        dId = value.docs[0]['id'];
        dGeo = value.docs[0]['driverLocation'];

        FirebaseFirestore.instance.collection('drivers').doc(dId).update({
          'order_details': {
            'source': widget.sourceLocationName,
            'destination': widget.destinationName,
            'truck': 'Large',
            'customer_name': FirebaseAuth.instance.currentUser!.displayName ?? '',
            'customer_email': FirebaseAuth.instance.currentUser!.email ?? '',
          },
        });
      }
      // for (var element in value.docs) {
      //   print(element['name']);
      // }
    });
  }

  late GeoPoint dGeo;
  driverGeo() async {
    FirebaseFirestore.instance
        .collection('drivers')
        // .where("id", isEqualTo: dId)
        .get()
        .then((value) {
      dGeo = value.docs[0]['driverLocation'];
      // print("driver latitude: ${dGeo!.latitude}");
      // print("driver longitude: ${dGeo!.longitude}");
    });
  }

  void _showDialogCancelRide() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      title: 'Cancel TrackService Request!',
      desc: 'Are you sure you want to cancel the service?',
      btnOkOnPress: endRide,
      btnOkColor: Colors.orange,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  void showDriverDetails() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 700,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: FutureBuilder(
            future: getData(widget.sName),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(100, 237, 237, 237),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dName.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$dRides trip(s)",
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Uri phoneDr = Uri.parse(
                                'tel:$dNumber',
                              );

                              if (await launchUrl(phoneDr)) {
                                debugPrint("Phone number is okay");
                              } else {
                                debugPrint('phone number errror');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(100, 237, 237, 237),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.call),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Call")
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(100, 237, 237, 237),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.wifi_calling_3_rounded),
                          ),
                          const SizedBox(height: 5),
                          const Text("Internet call")
                        ],
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showReportRider() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: 'Report driver!',
      desc: 'Report the driver to the closest auhority',
      btnOkOnPress: () {},
      btnOkColor: Colors.orange,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  void rateRider() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                  "Delivery success        "), // !important : don't edit the space
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // Location functions -----------

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};

  // int _polylineIdCounter = 1;

  Future<dynamic> drawRide() async {
    NotificationService()
        .showNotification(title: "TruckService", body: "Driver has arrived");
    var directions = await LocationService().getDirection(
      widget.sourceLocationName.toString(),
      widget.destinationName.toString(),
      // 'kampala',
      // 'entebbe',
    );
    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );
// !here the polyline is visible when you use setState
    // setState(() {
    //   _setPolyline(directions['polyline_decoded']);
    // });

    _setPolyline(directions['polyline_decoded']);
  }

  Future<dynamic> trackRide() async {
    Fluttertoast.showToast(
      msg: "Finding a truck",
      gravity: ToastGravity.TOP,
    );
    // BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(size: Size(48, 48)),
    //   'images/locationpin.png',
    // );
    final GoogleMapController controller = await _controller.future;

    Timer.periodic(const Duration(milliseconds: 1500), (timer) async {
      // driverGeo().then((value) => {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(dGeo.latitude, dGeo.longitude),
            zoom: 15.47,
            tilt: 50,
          ),
        ),
      );
      // });

      setState(() {
        _markers.add(
          Marker(
              visible: true,
              draggable: false,
              infoWindow: const InfoWindow(title: "Truck location"),
              markerId: const MarkerId('track_marker'),
              position: LatLng(dGeo.latitude, dGeo.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              )),
        );
      });
    });
    // lat and lng converter
  }

  void endRide() async {
    FirebaseFirestore.instance.collection('drivers').doc(dId).update({
      "driver_free": true,
      "driver_arrived": "waiting",
    }).then((value) => {
          _polylines.clear(),
          _markers.clear(),
          Fluttertoast.showToast(
            msg: "Thank you for using TruckService",
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
          Navigator.of(context).pop(),
        });
  }

  void _setMarker(LatLng points) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: points,
          infoWindow: InfoWindow(title: widget.sourceLocationName),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    const String polylineIdval = 'polyline_1';
    // 'polyline_$_polylineIdCounter';
    // _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: const PolylineId(polylineIdval),
        width: 6,
        color: Colors.red,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  // Ride distance in kilometres
  var km;

  getDis() async {
    var directions = await LocationService().getDirection(
      widget.sourceLocationName.toString(),
      widget.destinationName.toString(),
    );
    setState(() {
      km = directions['distance_km']['text'].toString();
    });
    // final distanceString = km.replaceAll(RegExp(r'[^0-9\.]'), '');
    // final distance = double.parse(distanceString) * 1000.0;
    // return distance;

    // debugPrint(directions['distance_km']['text']);
  }

  double price = 0;

  double pricePerTruck() {
    final truckChosen = ref.read(truckchosen.notifier).state;
    // final double kmValue = double.parse(km?.replaceAll(RegExp(r'[^0-9\.]'), ''));
    int kmValue = int.parse(km.toString().replaceAll(RegExp('[^0-9]'), ''));

    if (truckChosen == 1) {
      return kmValue * 3000;
    } else if (truckChosen == 2000) {
      return kmValue * 2;
    } else if (truckChosen == 3) {
      return kmValue * 1000;
    } else {
      return 0;
    }
  }

  // var price = double.parse('300000');

  var conditionMet = false;

  @override
  void initState() {
    super.initState();
    getData(widget.sName);
    trackRide();
    getDis();    
    showDriverDetails();

    // ? these were replicates
    // getData();
    // driverGeo();
    // drawRide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "TruckService",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "${km ?? ''}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
      // ! why are they null.   ..............................................................................................................................
      body: SafeArea(
        child: dName != null &&
                dNumber != null &&
                dPlate != null &&
                dRating != null &&
                dId != null
            ? Stack(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('drivers')
                        .where("name", isEqualTo: dName)
                        .where("number", isEqualTo: dNumber)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('No data available');
                      }

                      var status = snapshot.data!.docs[0]['driver_arrived'];
                      var status2 = snapshot.data!.docs[0]['trip_accepted'];
                      FirebaseFirestore.instance
                          .collection('drivers')
                          .doc(dId)
                          .update({"chosen": true, "driver_free": false});

                      if (status2 == "true") {
                        NotificationService().showNotification(
                            title: "TruckService",
                            body: "Driver has accepted your request");
                      }
                      if (status2 == "false") {
                        NotificationService().showNotification(
                            title: "TruckService",
                            body: "Driver has rejected your request");
                      }

                      if (status == "true") {
                        // && !conditionMet
                        NotificationService()
                            .showNotification(
                                title: "TruckService",
                                body: "Driver has arrived at the destination")
                            .then((value) => FirebaseFirestore.instance
                                    .collection('drivers')
                                    .doc(dId)
                                    .update({
                                  "driver_free": true,
                                }));

                        // conditionMet = true;
                      }
                      if (status == "complete") {
                        NotificationService()
                            .showNotification(
                                title: "TruckService", body: "Ride is complete")
                            .then((value) => drawRide());
                      }

                      return GoogleMap(
                        compassEnabled: false,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        markers: _markers,
                        polylines: _polylines,
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            dGeo.latitude,
                            dGeo.longitude,
                          ),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      );
                    },
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.2,
                    maxChildSize: 0.42,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(15, 0, 0, 0),
                                blurRadius: 12,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 199, 199, 199),
                                ),
                              ),
                              const SizedBox(height: 19),

                              // 1st part start
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 12,
                                      right: 12,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(100, 237, 237, 237),
                                    ),
                                    child: Text(
                                      dPlate.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 23,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Chip(
                                        backgroundColor: Colors.grey[100],
                                        label: Text(
                                          'Shs. ${pricePerTruck()}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // 2nd Part
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: showDriverDetails,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              100,
                                              237,
                                              237,
                                              237,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Icon(Icons.person),
                                        ),
                                      ),
                                      Text(
                                        dName.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.blue,
                                            size: 12,
                                          ),
                                          Text(dRating.toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: showReportRider,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                100, 237, 237, 237),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Icon(
                                              Icons.fire_truck_rounded),
                                        ),
                                      ),
                                      const Text(
                                        "Report driver",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      // The text widget below is a space
                                      const Text(""),
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 15),

                              // third part
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          widget.sourceLocationName,
                                          style: const TextStyle(
                                              overflow: TextOverflow.fade),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.delivery_dining_outlined,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          widget.destinationName,
                                          style: const TextStyle(
                                              overflow: TextOverflow.fade),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              // Fourth part,
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: _showDialogCancelRide,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10),
                                  ),
                                  // backgroundColor: MaterialStateProperty.all<Color>(),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cancel TruckService ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ending||
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 4),
                    const SizedBox(height: 18),
                    const Text("Searching for driver please wait..."),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        // showDriverDetails();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "cancel search",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15.47,
          tilt: 50,
        ),
      ),
    );

// create bounding box for the map zoom
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          15),
    );

    setState(() {
      _setMarker(LatLng(lat, lng));
    });
  }
}
