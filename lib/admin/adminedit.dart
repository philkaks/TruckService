// import 'package:flutter/material.dart';

// class EditDetailsScreen extends StatefulWidget {
//   final String userId; // Pass the user/driver ID as an argument
//   final String name;
//   final String phoneNumber;
//   final bool phoneNumberVerification;

//   EditDetailsScreen({
//     required this.userId,
//     required this.name,
//     required this.phoneNumber,
//     required this.phoneNumberVerification,
//   });

//   @override
//   _EditDetailsScreenState createState() => _EditDetailsScreenState();
// }

// class _EditDetailsScreenState extends State<EditDetailsScreen> {
//   // Create TextEditingController for editing the fields
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the text controllers with the current values
//     nameController.text = widget.name;
//     phoneNumberController.text = widget.phoneNumber;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: phoneNumberController,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//             ),
//             // Add more fields as needed for other details
//             ElevatedButton(
//               onPressed: () => _saveChanges(),
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _saveChanges() {
//     // Save the changes to Firestore
//     String newName = nameController.text;
//     String newPhoneNumber = phoneNumberController.text;
//     // Update the Firestore document with the new details
//     // For example, using FirebaseFirestore.instance.collection('users').doc(widget.userId).update(...);

//     // Optionally, update the state of the parent screen to reflect the changes
//     // For example, use a provider or a callback function to update the user list
//     // after the changes are saved.

//     Navigator.pop(
//         context); // Go back to the previous screen after saving changes.
//   }
// }
