import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini/screens/chat_screen.dart';
import 'package:mini/screens/welcome_screen.dart';
Future<User?> createAccount(String email,String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  try {
    User? user = (await auth.createUserWithEmailAndPassword(
        email: email, password: password)).user;

  if (user != null) {
    print('sucess');
    await firestore.collection('users').doc(auth.currentUser?.uid).set({
      "email":email,
      "status":"unav",
    });
    return user;
  }
  else {
    print('acc failed');
    return user;
  }
}
  catch(e){
    print((e));
    return null;

  }
}
Future<User?> login(String email,String password) async{
  FirebaseAuth auth=FirebaseAuth.instance;

  try{
    User? user=(await auth.signInWithEmailAndPassword(email: email, password: password)).user;
  if(user!=null){
    print('user in');
    return user;
  }
  }
  catch(e){
    print('failed');
    return null;
  }
}
Future logout(BuildContext context) async{
  FirebaseAuth auth=FirebaseAuth.instance;
  try{
    await auth.signOut();
    Navigator.pushNamed(context, WelcomeScreen.id);
  }
  catch(e){
    print('error');
  }
}