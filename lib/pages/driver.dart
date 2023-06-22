// import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:upbox/services/storage_service.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _Driver();
}

class _Driver extends State<Driver> {
  final User? user = Auth().currentUser;
// final page = AccountPage();
  void _showSignOut() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: 'Confirm logout!',
      desc: 'Are you sure you want to logout?',
      btnOkOnPress: signOut,
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

  // ignore: prefer_typing_uninitialized_variables
  var imageName;
  getImage() async {
    await FirebaseFirestore.instance
        .collection('people')
        .doc('drivers')
        .get()
        .then((value) {
      setState(() {
        imageName = value.data()!['image_url'];
      });

      debugPrint('image url is :  $imageName');
    });
  }

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("people");

  final Storage storage = Storage();

  @override
  void initState() {
    // getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      // color: const Color.fromARGB(255, 198, 197, 197),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // FutureBuilder(
                    //   future: storage.downloadUrl("$imageName"),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasError) {
                    //       return IconButton(
                    //         color: Colors.black,
                    //         icon: const Icon(Icons.person),
                    //         onPressed: () async {
                    //           final result =
                    //               await FilePicker.platform.pickFiles(
                    //             allowMultiple: false,
                    //             type: FileType.custom,
                    //             allowedExtensions: ['png', 'jpg'],
                    //           );

                    //           if (result == null) {
                    //             // ignore: use_build_context_synchronously
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text("No file selected"),
                    //               ),
                    //             );
                    //             // ignore: avoid_returning_null_for_void
                    //             return null;
                    //           }

                    //           final path = result.files.single.path!;
                    //           final fileName = result.files.single.name;

                    //           FirebaseFirestore.instance
                    //               .collection('people')
                    //               .doc('drivers')
                    //               .update({'image_url': user!.uid + fileName});
                    //           storage
                    //               .uploadFile(path, user!.uid + fileName)
                    //               .then((value) {
                    //             // ignore: use_build_context_synchronously
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                 content: Text("Image saved successfully"),
                    //                 backgroundColor: Colors.green,
                    //               ),
                    //             );
                    //           });
                    //         },
                    //       );
                    //     } else if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     return Container(
                    //       width: 75,
                    //       height: 75,
                    //       color: const Color.fromARGB(255, 198, 197, 197),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         image: DecorationImage(
                    //           image: NetworkImage(snapshot.data!),
                    //           fit: BoxFit.fill,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 5),
                    // FutureBuilder(
                    //   future: FirebaseFirestore.instance
                    //       .collection("users")
                    //       .where("id", isEqualTo: user!.uid)
                    //       .get(),
                    //   builder:
                    //       (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    //     if (snapshot.hasData) {
                    //       var name =
                    //           snapshot.data!.docs[0]['username'].toString();
                    //       return Text(
                    //         name,
                    //         style: const TextStyle(
                    //             fontSize: 26, fontWeight: FontWeight.bold),
                    //       );
                    //     }
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const CircularProgressIndicator();
                    //     }
                    //     return const Text(
                    //       "error",
                    //       style: TextStyle(color: Colors.red),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 10),
                    const Text(
                      "Drivers Name",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    // const SizedBox(height: 30),
                    const Text(
                      "0770-423-412",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Status'),
                        SizedBox(width: 10),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    )
                    // const Text(
                    //   "0770-423-412",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance
                    //       .collection("users")
                    //       .where("id", isEqualTo: user!.uid)
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasError) {
                    //       return Text(
                    //         '${snapshot.error}',
                    //         style: const TextStyle(
                    //           color: Colors.red,
                    //         ),
                    //       );
                    //     } else if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const Text("Loading....");
                    //     }
                    //     Widget numbVer() {
                    //       if (snapshot.data!.docs[0]['phoneNumberVerification']
                    //               .toString() ==
                    //           "true") {
                    //         return const Text(
                    //           "Verified",
                    //           style: TextStyle(
                    //             color: Colors.green,
                    //           ),
                    //         );
                    //       } else {
                    //         return GestureDetector(
                    //           onTap: () {
                    //             // verify phone number if not verified
                    //           },
                    //           child: Container(
                    //             padding: const EdgeInsets.all(5.0),
                    //             decoration: BoxDecoration(
                    //               color: Colors.orange.withOpacity(0.5),
                    //             ),
                    //             child: const Text(
                    //               "un-verified",
                    //               style: TextStyle(
                    //                 color: Colors.red,
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //     }

                    //     return ListTile(
                    //       leading: const Icon(Icons.phone_iphone_outlined),
                    //       title: Text(
                    //         snapshot.data!.docs[0]['phonenumber'].toString(),
                    //       ),
                    //       trailing: numbVer(),
                    //       onTap: () {},
                    //     );
                    //   },
                    // ),

                    const Divider(
                      height: 10,
                    ),
                    // const Divider(
                    //   height: 10,
                    // ),
                    ListTile(
                      leading: const Icon(Icons.car_repair_outlined),
                      title: const Text("Trips Made."),
                      subtitle: const Text("5 trips "),
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
                      subtitle: const Text("UBG 123A"),
                      trailing: const Text('Address: Kampala'),
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
                      subtitle: const Text(
                        "phil@gmail.com",
                      ),
                      onTap: () {},
                    ),
                    const Divider(
                      height: 10,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.login_outlined,
                        size: 21,
                      ),
                      title: const Text(
                        "Log - out",
                        style: TextStyle(fontSize: 19),
                      ),
                      // subtitle: const Text("logout of your account"),
                      onTap: () {
                        // call the sign out function from accountpage
                        _showSignOut();                  
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage() ,
                          ),
                        );
                      
                        
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
