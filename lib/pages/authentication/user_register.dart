import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/app_start.dart';
// import 'package:upbox/pages/authentication/number_verification.dart';
import 'package:upbox/pages/authentication/user_login.dart';
import 'package:upbox/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMsg = '';
  // int selectedValue = 1;
  // String userType = 'users';
  // i want to use the value of the dropdown button in the createUserWithEmailAndPassword() method
  // final numberProvider = Provider<int>(create: (ref) => 1);
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

   String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  Future addUserDetails(
    String username,
    String email,
    String password,
  ) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    // if (userType == '') {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'id': userId,
      'name': username,
      'email': email,
      'password': password,
      'number': 'unknown',
      'userLocation':const GeoPoint(0.0, 0.0),
      'userType': 'users',
      'phoneNumberVerification': true,
      'image_url':
          'https://images.unsplash.com/photo-1530785602389-07594beb8b73?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
    });
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
                  height: 140,
                  // color: Colors.transparent,
                  child: Image.asset(
                    "images/app_icon.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fitHeight,
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

                      _errorMessage(),

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
                        autovalidateMode: AutovalidateMode.always,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        validator: validateEmail,
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
                        autovalidateMode: AutovalidateMode.always,
                        autocorrect: false,
                        obscureText: true,
                        validator: validatePassword,
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
                        height: 40,
                        color: Colors.transparent,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          createUserWithEmailAndPassword().then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppStart(),
                              ),
                            );
                          });
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

                      // Already a user.
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                              onPressed: () {
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
                              child: const Text('Log in'))
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
