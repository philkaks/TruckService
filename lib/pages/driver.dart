// import 'package:awesome_dialog/awesome_dialog.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/account/edit_account.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/pages/intro-screens/onboarding_screen.dart';
import 'package:upbox/services/auth.dart';

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
  void _showAction(text, action) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: text,
      desc: 'Are you sure you want to logout?',
      btnOkOnPress: action,
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

  Future<void> deleteAccount() async {
    Fluttertoast.showToast(
      msg: "Account deleted, We hope to see you again in the future",
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
    );
    await FirebaseAuth.instance.currentUser!.delete().then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const OnboardingScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          iconTheme: const IconThemeData(size: 30),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: const Text(
            "Driver's Account",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageTransition(
                    child: const EditAccount(),
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
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                // color: const Color.fromARGB(255, 198, 197, 197),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        data['image_url'].toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
    
                              const SizedBox(height: 10),
                              Text(
                                data['username'].toString(),
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
                                          Icons.cancel ,
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
                                leading: const Icon(Icons.car_repair_outlined),
                                title: const Text("Trips Made."),
                                subtitle: Text("${data['trips']} trips "),
                                trailing: const Text(
                                  "On-going trips: 0",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(Icons.language),
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
                                leading: const Icon(
                                  Icons.admin_panel_settings,
                                ),
                                title: const Text(
                                  "Contact Admin",
                                ),
                                subtitle: Text(
                                  'Contact the admin for any issues',
                                ),
                                onTap: () {
                                  

                                },
                              ),
                              const Divider(
                                height: 10,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.login_outlined,
                                  size: 21,
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      _showAction('Confirm delete account!',
                                          deleteAccount);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                    )),
                                title: const Text(
                                  "Log - out",
                                  style:
                                      TextStyle(fontSize: 19, color: Colors.red),
                                ),
                                onTap: () {
                                  _showAction('Confirm logout!', signOut);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
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
