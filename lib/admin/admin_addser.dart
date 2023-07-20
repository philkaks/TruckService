import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInformation extends StatefulWidget {
  const AddInformation({super.key, required this.collectionName});

  final String collectionName;

  @override
  State<AddInformation> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<AddInformation> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _createNewUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
    String collectionName,
  ) async {
    try {
      // Step 1: Create a new user account with email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid; // Get the unique user ID.

      // Step 2: Add the user details to Firestore with the user's email as the document ID.
      final CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection(widget.collectionName);

      if (collectionName == 'users') {
        await usersCollection.doc(userId).set({
          'name': name,
          'number': phoneNumber,
          'email': email,
          'password': password,
          'image_url':
              'https://images.unsplash.com/photo-1590079105886-f0f884bf4437?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=385&q=80',
          // Add other fields as needed...
          'phoneNumberVerification': true,
          'id': userId,
          'userLocation': const GeoPoint(0.0, 0.0),
        });
      } else if (collectionName == 'drivers') {
        await usersCollection.doc(userId).set({
          'name': name,
          'number': phoneNumber,
          'email': email,
          'password': password,
          'image_url':
              'https://images.unsplash.com/photo-1590079105886-f0f884bf4437?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=385&q=80',
          // Add other fields as needed...
          'phoneNumberVerification': false,
          'id': userId,
          'driverLocation': const GeoPoint(0.0, 0.0),
          'driver_arrived': 'true',
          'driver_free': true,
          'trips': 0,
          'rating': 0.0,
          'plateno': 'ABC-123',
          'state': 'kampala',
        });
      }

      Fluttertoast.showToast(
        msg: 'New user created successfully!',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (error) {
      print('Error creating new user: $error');
      Fluttertoast.showToast(
        msg: 'Failed to create new user. Please try again later.',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text('Add ${widget.collectionName} Information')),
        backgroundColor: Colors.white, // Set the app's theme color to blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            Chip(
              label: Text('Adding ${widget.collectionName} Information'),
              backgroundColor: Colors.blue,
              labelStyle: const TextStyle(color: Colors.white),
              avatar: const Icon(Icons.edit_attributes, color: Colors.white),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            TextFormField(
              controller: _emailController,
              validator: validateEmail,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              // validator: validatePassword,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.password,
                  color: Colors.blue,
                ),
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: Colors.blue,
                ),
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text;
                String name = _nameController.text.trim();
                String phoneNumber = _phoneNumberController.text.trim();

                if (email.isEmpty ||
                    password.isEmpty ||
                    name.isEmpty ||
                    phoneNumber.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please fill in all fields.',
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                  return;
                }

                await _createNewUserWithEmailAndPassword(
                  email,
                  password,
                  name,
                  phoneNumber,
                  widget.collectionName,
                ).then((value) => Navigator.pop(context));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the button's color to blue
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add ${widget.collectionName} data',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
