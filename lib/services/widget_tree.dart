import 'package:flutter/material.dart';
import 'package:upbox/homepage.dart';
import 'package:upbox/services/auth.dart';

import '../pages/authentication/user_login.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return 
    StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
          // OnboardingScreen();
        }
      },
    );
  }
}
