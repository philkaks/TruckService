import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/admin.dart';
import 'package:upbox/pages/app_start.dart';
import 'package:upbox/pages/authentication/user_register.dart';
import 'package:upbox/pages/driver.dart';
import 'package:upbox/services/auth.dart';

// import '../intro-screens/dropdown.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   // getData('users');
  //   // getData('drivers');
  //   // getData('adminstrators');
  //   // Provider.of<LocationProvider>(context, listen: false).initialization();
  // }
  String? errorMessage = '';
  bool isLogin = true;
  int selectedValue = 1;
  String userType = 'users';
  // var plateno;
  // var adminid;
  // var dId;
  // var userType ;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _adminid = TextEditingController();
  final TextEditingController _plateno = TextEditingController();

  // getData(usercollection) async {
  //   FirebaseFirestore.instance
  //       .collection(usercollection)
  //       .where("id", isEqualTo: dId)
  //       .get()
  //       .then((value) {
  //     plateno = value.docs[0]['plateno'];
  //     adminid = value.docs[0]['adminid'];
  //     userType = value.docs[0]['userType'];
  //     dId = value.docs[0]['id'];
  //   });
  // }

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      errorMessage = "Loading..please wait";
    });
    if (_controllerEmail.text == "" || _controllerPassword.text == "") {
      setState(() {
        errorMessage = 'Please, one or more fields are empty';
      });
    } else {
      try {
        if (selectedValue == 1) {
          await Auth()
              .signInWithEmailAndPassword(
                email: _controllerEmail.text.toString().trim(),
                password: _controllerPassword.text,
              )
              .then(
                (value) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const AppStart();
                  }),
                ),
              );
        } else if (selectedValue == 2 && _plateno.text.isNotEmpty) {
          await Auth()
              .signInWithEmailAndPassword(
                email: _controllerEmail.text.toString().trim(),
                password: _controllerPassword.text,
              )
              .then(
                (value) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const Driver();
                  }),
                ),
              );
        } else if (selectedValue == 3 && _adminid.text == "1234567890") {
          await Auth()
              .signInWithEmailAndPassword(
                email: _controllerEmail.text.toString().trim(),
                password: _controllerPassword.text,
              )
              .then(
                (value) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const AdminPage();
                  }),
                ),
              );
        } else {
          setState(() {
            errorMessage = 'Please, select a correct user type';
          });
        }
        // await Auth()
        //     .signInWithEmailAndPassword(
        //       email: _controllerEmail.text.toString().trim(),
        //       password: _controllerPassword.text,
        //     )
        //     .then(
        //       (value) => Navigator.of(context).push(
        //         MaterialPageRoute(builder: (BuildContext context) {
        //           return const AppStart();
        //         }),
        //       ),
        //     );
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          setState(() {
            errorMessage = "Sorry, cant find any accounts";
          });
        } else {
          setState(() {
            errorMessage = "Something is wrong here";
          });
        }
        debugPrint(e.code);
      }
    }
  }

  Widget _errorMessage() {
    if (errorMessage == "Loading..please wait") {
      return Text(
        errorMessage == '' ? '' : 'Umm, $errorMessage',
        style: const TextStyle(
          color: Colors.black,
        ),
      );
    }
    return Text(
      errorMessage == '' ? '' : 'Umm, $errorMessage',
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
                  height: 140,
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
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Sign In with your valid credentials",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Select the correct user type",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
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
                      Text('Selected: ${userType.toString()}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 16)),

                      Container(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      _errorMessage(),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _controllerEmail,
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
                        controller: _controllerPassword,
                        onEditingComplete: () {
                          signInWithEmailAndPassword();
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

                      Container(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      selectedValue == 3
                          ? TextFormField(
                              controller: _adminid,
                              onEditingComplete: () {
                                signInWithEmailAndPassword();
                              },
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key_outlined),
                                labelText: "Admin Password",
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            selectedValue == 2
                          ? TextFormField(
                              controller: _plateno,
                              onEditingComplete: () {
                                signInWithEmailAndPassword();
                              },
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.key_outlined),
                                labelText: "plate number",
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                      Container(
                        height: 40,
                        color: Colors.transparent,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          signInWithEmailAndPassword();
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
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // or sign up with a different account
                      const SizedBox(height: 18),
                      const Center(
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),

                      // sign in with google
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(20),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black12),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/google.png",
                              width: 18,
                            ),
                            const SizedBox(width: 19),
                            const Text(
                              "Sign In with Google",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),

                      // Already a user.
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          InkWell(
                            child: const Text(
                              " Sign Up",
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: const RegisterPage(),
                                  childCurrent: widget,
                                  type: PageTransitionType.rightToLeftJoined,
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
