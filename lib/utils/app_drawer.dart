import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/account/account_page.dart';
import 'package:upbox/services/auth.dart';

import '../pages/authentication/user_login.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final User? user = Auth().currentUser;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // final Storage storage = Storage();

  // ignore: prefer_typing_uninitialized_variables
  var imageName;
  // getImage() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('id', isEqualTo: user!.uid)
  //       .get()
  //       .then((value) {
  //     imageName = value.docs[0]['image_url'];

  //     debugPrint('image url is :  $imageName');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("id", isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // getImage();
                  var name = snapshot.data!.docs[0]['name'].toString();
                  return Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return const Text(
                  "error",
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
            accountEmail: Text(user?.email ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child: Icon(Icons.person),
              ),
            ),
            // currentAccountPicture: FutureBuilder(
            //   future: storage.downloadUrl("$imageName"),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            // const CircleAvatar(
            //   child: ClipOval(
            //     child: Icon(Icons.person),
            //   ),
            // );
            //     } else if (snapshot.hasData) {
            //       return CircleAvatar(
            //         child: Container(
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             image: DecorationImage(
            //               image: NetworkImage(snapshot.data!),
            //               fit: BoxFit.fill,
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //     return const CircleAvatar(
            //       backgroundColor: Color.fromARGB(255, 225, 225, 225),
            //       child: ClipOval(
            //         child: Icon(
            //           Icons.person,
            //           color: Colors.black,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              "Account",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  child: const AccountPage(),
                  childCurrent: this,
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onTap: () async {
              // temporary
              await Auth().signOut().then(
                    (value) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const LoginPage();
                        },
                      ),
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}
