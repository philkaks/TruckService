import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/app_start.dart';
// import 'package:upbox/pages/authentication/number_verification.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/services/auth.dart';

import '../admin.dart';
import '../driver.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMsg = '';
  int selectedValue = 1;
  String userType = 'users';
  // i want to use the value of the dropdown button in the createUserWithEmailAndPassword() method
  // final numberProvider = Provider<int>(create: (ref) => 1);
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _plateno = TextEditingController();
  final TextEditingController _telno = TextEditingController();
  final TextEditingController _adminid = TextEditingController();
  final TextEditingController _city = TextEditingController();

  Future createUserWithEmailAndPassword() async {
    setState(() {
      errorMsg = "Loading...please wait";
    });
    if (_name.text == '' || _email.text == '' || _password.text == '') {
      setState(() {
        errorMsg = 'Please, one or more fields are empty';
      });
    } else {
      try {
        await Auth()
            .createUser(
          email: _email.text.toString().trim(),
          password: _password.text,
        )
            .then(
          (value) {
            addUserDetails(
              _name.text.trim(),
              _email.text.toString().trim(),
              _password.text.trim(),
            );
            // .then(
            //   (value) {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) {
            //           return const NumberRegister();
            //         },
            //       ),
            //     );
            //   },
            // );
          },
        );
      } on FirebaseException catch (e) {
        if (e.code == "email-already-in-use") {
          setState(() {
            errorMsg = 'Sorry, email is already taken';
          });
        } else if (e.code == "weak-password") {
          setState(() {
            errorMsg = "Password must contain atleast 6 characters";
          });
        } else {
          setState(() {
            errorMsg = "Sorry, something went wrong";
          });
        }
        debugPrint(e.code);
      }
    }
  }
// i need to use the value of the dropdown button in the createUserWithEmailAndPassword() method
  // Future createUserWithEmailAndPassword() async {
  //   setState(() {
  //     errorMsg = "Loading...please wait";
  //   });
  //   if (_name.text == '' || _email.text == '' || _password.text == '') {
  //     setState(() {

  Future addUserDetails(
    String username,
    String email,
    String password,
  ) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userType == 'users') {
      await FirebaseFirestore.instance.collection(userType).doc(userId).set({
        'id': userId,
        'username': username,
        'email': email,
        'password': password,
        'phonenumber': 'unknown',
        'phoneNumberVerification': false,
        'user_lat': 'unknown',
        'user_lng': 'unknown',
        'userType': 'users',
      });
    }
    if (userType == 'drivers') {
      await FirebaseFirestore.instance.collection(userType).doc(userId).set({
        'id': userId,
        'username': username,
        'email': email,
        'password': password,
        'phoneNumberVerification': false,
        'plateno': _plateno.text.toString().trim(),
        'number': _telno.text.toString().trim(),
        'state': _city.text.toString().trim(),
        'driver_lat': 'unknown',
        'driver_lng': 'unknown',
        'userType': 'drivers',
      });
    } else if (userType == 'adminstrators') {
      await FirebaseFirestore.instance.collection(userType).doc(userId).set({
        'id': userId,
        'username': username,
        'email': email,
        'password': password,
        'adminid': _adminid.text.toString().trim(),
        'userType': 'admin',
      });
    }
  }

  Widget _errorMessage() {
    if (errorMsg == "Loading...please wait") {
      return Text(
        errorMsg == '' ? '' : 'Umm, $errorMsg',
        style: const TextStyle(
          color: Colors.black,
        ),
      );
    }
    return Text(
      errorMsg == '' ? '' : 'Umm, $errorMsg',
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  height: 120,
                  // color: Colors.transparent,
                  child: Image.asset(
                    "images/top.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Register with your valid credentials",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      // Container(
                      //   height: 10,
                      //   color: Colors.transparent,
                      // ),
                      _errorMessage(),
                      // THE drop down menu
                      DropdownButton(
                        hint: const Text("Select a user type"),
                        value: selectedValue,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text("USER"),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text("DRIVER"),
                          ),
                          DropdownMenuItem(
                              value: 3, child: Text("ADMINSTRATOR")),
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              selectedValue = value!;
                              if (selectedValue == 1) {
                                userType = "users";
                              } else if (selectedValue == 2) {
                                userType = "drivers";
                              } else if (selectedValue == 3) {
                                userType = "adminstrators";
                              }
                            },
                          );
                        },
                      ),

                      TextFormField(
                        controller: _name,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      TextFormField(
                        controller: _email,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      TextFormField(
                        controller: _password,
                        onEditingComplete: () {
                          createUserWithEmailAndPassword();
                        },
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.key_outlined),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      if (selectedValue == 2)
                        Column(
                          children: [
                            Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _telno,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              autocorrect: true,
                              decoration: InputDecoration(
                                labelText: "Telephone Number",
                                prefixIcon:
                                    const Icon(Icons.phone_android_outlined),
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _plateno,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              autocorrect: true,
                              decoration: InputDecoration(
                                labelText: "Plate Number",
                                prefixIcon:
                                    const Icon(Icons.car_repair_outlined),
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _city,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              autocorrect: true,
                              decoration: InputDecoration(
                                labelText: "City of Operation",
                                prefixIcon:
                                    const Icon(Icons.car_repair_outlined),
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (selectedValue == 3)
                        Column(
                          children: [
                            Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              controller: _adminid,
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                              autocorrect: true,
                              decoration: InputDecoration(
                                labelText: "Adminstrator ID",
                                prefixIcon:
                                    const Icon(Icons.phone_android_outlined),
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        height: 40,
                        color: Colors.transparent,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          createUserWithEmailAndPassword();
                          if (selectedValue == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppStart(),
                              ),
                            );
                          } else if (selectedValue == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Driver()),
                            );
                          } else if (selectedValue == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminPage()),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LoginPage(),
                          //   ),
                          // );
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(20),
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // or sign up with a different account
                      // const SizedBox(height: 18),
                      // const Center(
                      //   child: Text(
                      //     "or",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 19,
                      //     ),
                      //   ),
                      // ),

                      // // sign up with google
                      // const SizedBox(height: 18),
                      // TextButton(
                      //   onPressed: () {},
                      //   style: ButtonStyle(
                      //     padding: MaterialStateProperty.all<EdgeInsets>(
                      //       const EdgeInsets.all(20),
                      //     ),
                      //     shape:
                      //         MaterialStateProperty.all<RoundedRectangleBorder>(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         side: const BorderSide(color: Colors.black12),
                      //       ),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         "images/google.png",
                      //         width: 18,
                      //       ),
                      //       const SizedBox(width: 19),
                      //       const Text(
                      //         "Sign up with Google",
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),

                      // Already a user.
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          InkWell(
                            child: const Text(
                              " Log in",
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: const LoginPage(),
                                  childCurrent: widget,
                                  type: PageTransitionType.leftToRightJoined,
                                  duration: const Duration(seconds: 0),
                                  reverseDuration: const Duration(seconds: 0),
                                ),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
