import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/local_notification_service.dart';
import 'editdriver.dart';
import 'reviews.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _Driver();
}

class _Driver extends State<Driver> {
  // final User? user = Auth().currentUser;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> dataStream =
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

// final page = AccountPage();
  void _showAction() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: 'Logout',
      desc: 'Are you sure you want to logout?',
      btnOkOnPress: () {
        signOut();
      },
      btnOkColor: Colors.black,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  Future<void> signOut() async {
    Fluttertoast.showToast(
      msg: "You have been logged out",
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
    );
    await Auth().signOut().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const LoginPage();
              },
            ),
          ),
        );
  }

  LocationData? _locationData;
  final Location _location = Location();
  NotificationService notificationService = NotificationService();

  // final Location _location = Location();
  Future<void> _getCurrentLocation() async {
    try {
      final locData = await _location.getLocation();
      final databasepush = FirebaseFirestore.instance
          .collection('drivers')
          .doc(Auth().currentUser!.uid);

      _location.onLocationChanged.listen((LocationData currentLocation) {
        databasepush.update({
          'driverLocation': GeoPoint(
            currentLocation.latitude!,
            currentLocation.longitude!,
          ),
          // 'latitude': currentLocation.latitude,
          // 'longitude': currentLocation.longitude,
        });

        // Use current location
      });

      setState(() {
        _locationData = locData;
        // give the data to the location provider
        // ref.read(locationProvider.notifier).state = LatLng(
        //   _locationData!.latitude!,
        //   _locationData!.longitude!,
        // );
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
  // function to get local notification

  String drivername = 'paul';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // elevation: 2,
          iconTheme: const IconThemeData(size: 30),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: const Center(
            child: Text(
              "Driver's Account",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageTransition(
                    child: const EditDriver(),
                    childCurrent: widget,
                    type: PageTransitionType.fade,
                    duration: const Duration(seconds: 0),
                    reverseDuration: const Duration(seconds: 0),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                size: 20,
                color: Colors.green,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.data();

                  if (data != null) {
                    // todo this is notifcation persists. need to correct it
                    if (data['chosen'] == true) {
                      NotificationService().showNotification(
                        title: "TruckService",
                        body: "You have an order",
                      );
                    }
                    drivername = data['name'].toString();
                    // String   dId = ;
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 1.2,
                                // color: const Color.fromARGB(255, 198, 197, 197),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: googlemapsUI(),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                data['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              // const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['number'].toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  data['phoneNumberVerification']
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    splashColor: Colors.yellow,
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('drivers')
                                          .doc(data['id'])
                                          .update({
                                        // "driver_free": false,
                                        'chosen': false,
                                      });
                                    },
                                    child: Chip(
                                      backgroundColor: Colors.green[100],
                                      label: const Text('Accept Trip'),
                                      avatar: const Icon(Icons.forward_outlined,
                                          color: Colors.green),
                                    ),
                                  ),
                                  // SizedBox(
                                  //     width: MediaQuery.of(context).size.width /
                                  //         4.4),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    splashColor: Colors.yellow,
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('drivers')
                                          .doc(data['id'])
                                          .update({
                                        "driver_arrived": 'true',
                                      });
                                    },
                                    child: Chip(
                                      backgroundColor: Colors.blue[100],
                                      label: const Text('Arrived'),
                                      avatar: const Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.blue),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  InkWell(
                                    splashColor: Colors.yellow,
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('drivers')
                                          .doc(data['id'])
                                          .update({
                                        "driver_arrived": 'complete',
                                        // 'chosen': false,
                                      });
                                    },
                                    child: Chip(
                                      backgroundColor: Colors.red[100],
                                      label: const Text('End Trip'),
                                      avatar: const Icon(
                                          Icons.stop_circle_outlined,
                                          color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                trailing: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                leading: const Icon(
                                  Icons.call_end_rounded,
                                  color: Colors.green,
                                ),
                                title: const Text(
                                  "Contact Customer ",
                                ),
                                subtitle: const Text(
                                  'Contact the customer incase of any issues',
                                ),
                                onTap: () async {
                                  Uri phoneDr =
                                      Uri.parse('tel:+256 770 429 423');

                                  if (await launchUrl(phoneDr)) {
                                    debugPrint("Phone number is okay");
                                  } else {
                                    debugPrint('phone number errror');
                                  }
                                },
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.reviews_outlined,
                                  color: Colors.blue,
                                ),
                                title: const Text("order-Details"),
                                subtitle: data['driver_free']
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('\n  From:  ' +
                                        data['order_details']['source']),
                                    Text('\n  To:  ' +
                                        data['order_details']['destination']),
                                    Text('\n   Trucksize:  ' +
                                        data['order_details']['truck']),
                                  ],
                                )
                                    : const Text('No ogoing order'),
                                onTap: () {
                                  drivername =
                                      data['name'].toString().toLowerCase();
                                  // print(drivername);
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: ReviewsList(
                                        driver: drivername,
                                      ),
                                      childCurrent: widget,
                                      type: PageTransitionType.fade,
                                      duration: const Duration(seconds: 0),
                                      reverseDuration:
                                          const Duration(seconds: 0),
                                    ),
                                  );
                                },
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.car_repair_outlined,
                                  color: Colors.blue,
                                ),
                                title: const Text('Trips'),
                                subtitle: Text("${data['trips']} trips "),
                                trailing: Text(
                                  data['driver_free'] ? 'NONE' : 'ONGOING',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                onTap: () {
                                  //todo add trip details such as customer name, destination location, destination, price, etc
                                },
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.card_membership,
                                  color: Colors.blue,
                                ),
                                title: const Text("Number Plate"),
                                subtitle: Text("${data['plateno']}"),
                                // trailing: Text('Address: '),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue,
                                ),
                                title: const Text(
                                  "Email",
                                ),
                                subtitle: Text(
                                  data['email'].toString(),
                                ),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                trailing: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                leading: const Icon(
                                  Icons.admin_panel_settings,
                                  color: Colors.green,
                                ),
                                title: const Text(
                                  "Contact Admin",
                                ),
                                subtitle: const Text(
                                  'Contact the admin for any issues',
                                ),
                                onTap: () async {
                                  Uri phoneDr = Uri.parse(
                                    'tel:+256 770 429 423',
                                  );

                                  if (await launchUrl(phoneDr)) {
                                    debugPrint("Phone number is okay");
                                  } else {
                                    debugPrint('phone number errror');
                                  }
                                },
                              ),
                              const Divider(
                                height: 10,
                              ),
                              Container(
                                color: Colors.red[50],
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.login_outlined,
                                    size: 21,
                                    color: Colors.red,
                                  ),
                                  title: const Text(
                                    "Log - out",
                                    style: TextStyle(
                                        fontSize: 19, color: Colors.red),
                                  ),
                                  subtitle: const Text(
                                    'Log out of your account',
                                    // style: TextStyle(
                                    //   color: Colors,
                                    // ),
                                  ),
                                  onTap: () {
                                    _showAction();
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const LoginPage(),
                                    //   ),
                                    // );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }
                return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
              },
            ),
          ),
        ),
      ),
    );
  }

  GoogleMap googlemapsUI() {
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
                markerId: const MarkerId('m2'),
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
