import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini/method.dart';
import 'package:flutter/material.dart';
import 'package:mini/screens/chatroom.dart';
class HomeScreen extends StatefulWidget {
static String id="home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   Map <String,dynamic>? userMap;
   final FirebaseAuth _auth = FirebaseAuth.instance;
bool isloading=false;
final TextEditingController _search=TextEditingController();
   String chatRoomId(String user1, String user2) {
     if (user1[0].toLowerCase().codeUnits[0] >
         user2.toLowerCase().codeUnits[0]) {
       return "$user1$user2";
     } else {
       return "$user2$user1";
     }
   }
void onSearch ()async{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  setState(() {
    isloading=true;
  });
  await _firestore.collection("users").where("email",isEqualTo: _search.text).get()
  .then((value){

setState(() {
  userMap=value.docs[0].data();
  isloading=false;
});
print(userMap);
  });

}

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(onPressed: ()=>logout(context), icon: Icon(Icons.logout))
        ],
      ),
      body: isloading?
          Center(child: Container(
            height: size.height/14,
            width:size.width/20,
            child: CircularProgressIndicator(),

          ),):Column(
        children: [
          SizedBox(
            height:size.height/20 ,
          ),
          Container(
            height: size.height/14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width/1.2,
              child: TextField(
                controller:_search ,
                decoration: InputDecoration(

                  hintText: "search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),

              ),
            ),
          ),
          SizedBox(
            height: size.height/30,
          ),
          ElevatedButton
            (onPressed:  onSearch,
            child: Text("search"),
          ),
          SizedBox(
            height: size.height/20,
            width: size.width/20,
          ),
          userMap != null
              ? ListTile(
            onTap: (){
              String roomId = chatRoomId(
                  _auth.currentUser!.uid,
                  userMap!['email']);
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ChatRoom(
                chatRoomId: roomId,
                userMap: userMap!,
              )));
            },
            title: Text(_search.text),
           leading: Icon(Icons.chat),
          )
              :Container(),
        ],
      ),
    );

  }


}


