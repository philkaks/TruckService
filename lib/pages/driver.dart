// import 'package:awesome_dialog/awesome_dialog.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';
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

  String drivername = 'paul';
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
                    drivername = data['name'].toString();
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
                                child: googleMapUI(),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                data['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              // const SizedBox(height: 30),
                              Text(
                                data['number'].toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Status'),
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
                                leading: const Icon(
                                  Icons.reviews_outlined,
                                  color: Colors.blue,
                                ),
                                title: const Text("Read Your Reviews"),
                                subtitle: const Text(
                                    "From the people you've Worked on."),
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
                                title: const Text("Trips Made."),
                                subtitle: Text("${data['trips']} trips "),
                                trailing: const Text(
                                  "On-going trips: none",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onTap: () {},
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
                                  trailing: IconButton(
                                      onPressed: () {
                                        // _showAction('Confirm delete account!',
                                        //     deleteAccount);
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                      )),
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
}

Widget googleMapUI() {
  return const GoogleMap(
    trafficEnabled: false,
    myLocationButtonEnabled: false,
    myLocationEnabled: true,
    compassEnabled: false,
    mapType: MapType.normal,
    initialCameraPosition: CameraPosition(
      target: LatLng(0.347596, 32.582520),
      zoom: 15,
    ),
    // onMapCreated: (GoogleMapController controller) {
    //   controller.complete(controller);
    // },
  );
}
