import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/auth.dart';
import '../pages/authentication/user_login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int numberofdrivers = 0;

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

  // Future<int> getUsersCount() async {
  //   final QuerySnapshot<Map<String, dynamic>> users =
  //       await FirebaseFirestore.instance.collection('users').get();
  //   print(users.docs.length);
  //   return users.docs.length;
  // }

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

  Future<void> _editDetailsOverlay(
    String docId,
    String name,
    String phoneNumber,
    String email,
    String image,
    String category,
    // bool phoneNumberVerification,
  ) async {
    String newName = name;
    String newPhoneNumber = phoneNumber;
    String newEmail = email;
    String newImage = image;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text: 'Edit Details for ',
                    style: TextStyle(
                        // fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                TextSpan(
                    text: name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
              ],
            ),
          ),
          icon: const Icon(Icons.edit),
          content: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: TextEditingController(text: newName),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: newPhoneNumber),
                    onChanged: (value) {
                      newPhoneNumber = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: newEmail),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'email',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: newImage),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'image',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection(category)
                            .doc(docId)
                            .update({
                          'name': newName,
                          'number': newPhoneNumber,
                        }).then((value) => Navigator.of(context).pop());

                        // Close the overlay.
                        Fluttertoast.showToast(
                          msg: 'Details updated successfully!',
                          gravity: ToastGravity.TOP,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } catch (error) {
                        print('Error updating details: $error');
                        Fluttertoast.showToast(
                          msg: 'Error updating details: $error',
                          gravity: ToastGravity.TOP,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      }

                      // Update the details in Firestore using userId, newName, and newPhoneNumber.
                      // Close the overlay.
                    },
                    child: const Text('Save Changes',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool selectedcategory = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true, // Set to false
        appBar: AppBar(
          elevation: 0,
          title: const Center(
              child: Text(
            'Dashboard',
            style: TextStyle(color: Colors.black),
          )),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: _showSignOut,
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Chip(
                    backgroundColor: selectedcategory
                        ? Colors.lightBlueAccent[50]
                        : Colors.lightBlueAccent,
                    label: const Text('Users'),
                    avatar: Icon(
                      Icons.people_outline_outlined,
                      color: selectedcategory ? Colors.blue : Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedcategory = false;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  child: Chip(
                    backgroundColor: selectedcategory
                        ? Colors.lightBlueAccent
                        : Colors.lightBlueAccent[50],
                    label: const Text('Drivers'),
                    avatar: Icon(
                      Icons.bubble_chart_sharp,
                      color: selectedcategory ? Colors.white : Colors.blue,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedcategory = true;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                selectedcategory ? 'Drivers Available' : 'Users Available',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // this creates the widget 10 times.
            selectedcategory ? getDrivers() : getUser(),
          ],
        ),
      ),
    );
  }

  Expanded getDrivers() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, snapshot) {
          // numberofdrivers = snapshot.data!.size;
          // print(numberofdrivers);
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w200));
          }

          final List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;
          numberofdrivers = documents.length;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final Map<String, dynamic> data = document.data()!;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['image_url']),
                  ),
                  title: Text(data['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['number']),
                  trailing: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      data['phoneNumberVerification']
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                      Text(
                        data['phoneNumberVerification']
                            ? 'Verified'
                            : 'Not Verified',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: data['phoneNumberVerification']
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    _editDetailsOverlay(
                      // Pass the collection name here
                      document.id, // Pass the user/driver ID
                      data['name'],
                      data['number'],
                      data['email'],
                      data['image_url'],
                      'drivers',
                    );
                  },

                  // Add more widgets to display other document fields as needed
                ),
              );
            },
          );
        },
      ),
    );
  }

  Expanded getUser() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // numberofdrivers = snapshot.data!.size;
          // print(numberofdrivers);
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w200));
          }

          final List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;
          numberofdrivers = documents.length;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final Map<String, dynamic> data = document.data()!;

              return Card(
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(data['image_url']),
                  ),
                  title: Text(data['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      ' Tel: ${data['number']}  \n email: ${data['email']}'),
                  trailing: data['phoneNumberVerification']
                      ? const Icon(
                          Icons.check_circle_sharp,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.wifi_protected_setup,
                          color: Colors.red,
                        ),
                  // Add more widgets to display other document fields as needed
                  onTap: () {
                    _editDetailsOverlay(
                      document.id, // Pass the user/driver ID
                      data['name'],
                      data['number'],
                      data['email'],
                      data['image_url'],
                      'users', // Pass the collection name here
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
