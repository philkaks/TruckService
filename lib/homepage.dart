import 'package:flutter/material.dart';
import 'pages/app_start.dart';
import 'dart:ui' as ui;

import 'tracking.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onCardTapped(int title) {
    String message = 'Card $title tapped!';
    print(message);
    // You can display a dialog or do any other action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Image.network(
                'https://images.unsplash.com/photo-1605705658744-45f0fe8f9663?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80', // Replace with your own image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 90,
              ),
              const Text(
                'Welcome to Truck Service!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Get ready to experience top-notch truck services.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.all(20),
                  children: [
                    ElevatedCard(
                      title: 'Order Now',
                      subtitle: 'Place your order',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppStart(),
                        ),
                      ),
                    ),
                    ElevatedCard(
                      title: 'Track',
                      subtitle: 'Track progress of your order',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackingPage(),
                        ),
                      ),
                    ),
                    ElevatedCard(
                      subtitle: 'Reach out to us',
                      title: 'Contact Us',
                      onTap: () => _onCardTapped(3),
                    ),
                    ElevatedCard(
                      title: 'Services',
                      subtitle: 'View our services',
                      onTap: () => _onCardTapped(4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w300),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class ElevatedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTap;

  const ElevatedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          // Add a border around the card
          side: const BorderSide(
            color: Colors.white, // Set the border color
            width: 1.0, // Set the border width
          ),
          borderRadius:
              BorderRadius.circular(8.0), // Set border radius if needed
        ),
        elevation: 8,
        child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: '$title\n',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  TextSpan(
                      text: subtitle,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: Colors.white)),
                ],
              ),
            )),
      ),
    );
  }
}
