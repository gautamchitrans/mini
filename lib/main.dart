import 'package:flutter/material.dart';
import 'package:mini/screens/chatroom.dart';
import 'package:mini/screens/home_screen.dart';
import 'package:mini/screens/welcome_screen.dart';
import 'package:mini/screens/login_screen.dart';
import 'package:mini/screens/registration_screen.dart';
import 'package:mini/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        HomeScreen.id: (context) => HomeScreen(),
         ChatRoom.id:(context)=>ChatRoom(),
      },
    );
  }
}
