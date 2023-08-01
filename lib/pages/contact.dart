import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 70,
                  child: Icon(Icons.person, size: 70),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  // right: BorderSide(color: Colors.red, width: 5)
                ),
                child: ListTile(
                  leading:
                      const Icon(Icons.phone, color: Colors.blue, size: 40),
                  title: const Text('Phone Number',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  subtitle: const Text('+ (256) 777-880015',
                      style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    Uri phoneDr = Uri.parse(
                      'tel:${'+ (256) 777-880015'}',
                    );

                    if (await launchUrl(phoneDr)) {
                      debugPrint("Phone number is okay");
                    } else {
                      debugPrint('phone number errror');
                    }
                  },
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  // right: BorderSide(color: Colors.red, width: 5)
                ),
                child: const ListTile(
                  leading: Icon(Icons.email, color: Colors.blue, size: 40),
                  title: Text('Email Address',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  subtitle: Text('help@truckservice.com',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  // right: BorderSide(color: Colors.red, width: 5)
                ),
                child: const ListTile(
                  leading:
                      Icon(Icons.location_on, color: Colors.blue, size: 40),
                  title: Text(
                    'Address',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('1234 Main Street, City, Country',
                      style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
