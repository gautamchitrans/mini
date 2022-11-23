import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
class ChatRoom extends StatelessWidget {
   Map<String,dynamic> ?userMap;
   String ?chatRoomId;
  ChatRoom({this.chatRoomId,this.userMap});
static String id='chatroom';
final TextEditingController _message=TextEditingController();

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   void onSendMessage() async {

     if (_message.text.isNotEmpty) {
       Map<String, dynamic> messages = {
         "sendby": _auth.currentUser!.uid.toString(),
         "message": _message.text,
         "type": "text",
         "time": FieldValue.serverTimestamp(),
       };

       _message.clear();
       await _firestore
           .collection('chatroom')
           .doc(chatRoomId)
           .collection('chats')
           .add(messages);

     } else {
       print("Enter Some Text");
     }
   }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap ?["email"]),

      ),
      body: Column(
        children: [
          Expanded(

            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data!= null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return messages(size, map);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: TextFormField(controller: _message,minLines: 1,maxLines: 5,
                decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey,width: 2)),
                hintText: "Enter messege"),)),
                IconButton(onPressed: onSendMessage, icon: Icon(Icons.send,size: 32,))
              ],
            ),
          ),
        ],
      ),
    );
  }
    Widget messages(Size size,Map<String,dynamic> map){
     return Container(
       width: size.width,
         alignment: map['sendby']! == _auth.currentUser ?
     Alignment.centerRight
       :Alignment.centerLeft,
       child: Container(
         padding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
         margin:EdgeInsets.symmetric(vertical: 5,horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue
        ),
         child: Text(map['messages'],
         style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.w500,
           color: Colors.white
         ),),
       ),
     );
    }


}
