import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini/method.dart';
import 'package:mini/screens/welcome_screen.dart';
class ChatScreen extends StatefulWidget {
 static String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore=FirebaseFirestore.instance;
   final auth=FirebaseAuth.instance;
 late User loggedInUser;
 late String messagetext;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {

               Navigator.pushNamed(context, WelcomeScreen.id);//Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(stream: firestore.collection('messages').snapshots(),
              builder: (context,snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  final messages = snapshot.data!.docs;
                  late List <Text> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data();
                    final messageSender = message.data();
                    final messageWidget = Text(
                        '$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );
                }
              }
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(

                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          messagetext=value;
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        firestore.collection('messages').add({
                          'text':messagetext,
                          'sender':loggedInUser.email,
                        });

                        //Implement send functionality.
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*void initState() {

    super.initState();
    getcurrentuser();
  }
  void getcurrentuser()async{
   try {
     final user = await auth.currentUser;
     if (user != null) {
       loggedInUser = user;
       print(loggedInUser.email);
     }
   }
   catch(e){
     print(e);
   }
  }
  void getmessages() async{
  final messages =await firestore.collection('messages').get();
  for(var messages in messages.docs){
    print(messages.data());
  }
  }
  void messagesStream() async{
    await for(var snapshot in firestore.collection('messages').snapshots()){
      for(var messages in snapshot.docs){
        print(messages.data());
      }
    }
  }*/
