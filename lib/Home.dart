import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Login_page.dart';
import 'package:flutterchatapp/Search.dart';

import 'Chat.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userid="";
  FirebaseAuth _auth=FirebaseAuth.instance;
  List _friends=[];
  List _name=[];
  @override
  void initState() {
    setState(() {
      _userid=_auth.currentUser!.uid.toString();
    });
    Help().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) { _friends.add(it); help(it); }
      });
    });
    super.initState();
  }
  Future<List<dynamic>> Help()async{
    List<dynamic> arr=[];
    final ref=FirebaseDatabase.instance.ref(_userid).child("friend");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      snapshot.children.forEach((child) {
        print(child.value);
        dynamic it=child.value as dynamic;
        arr.add(it);
      });
    }
    return arr;
  }
  Future<void> help(String s)async{
    dynamic ans="";
    final ref=FirebaseDatabase.instance.ref(s);
    final snapshot=await ref.child("Name").get();
    ans=snapshot.value as String;
    setState(() {
      _name.add(ans);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
          },
              icon: Icon(Icons.search))
        ],
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white54, Colors.blue],
          ),
        ),
        child: (_friends.length==0)?Center(child: Text("No Chats",style: TextStyle(fontSize: MediaQuery.of(context).size.height/20),),):
        ListView.builder(itemCount:_friends.length,itemBuilder: (BuildContext context,int index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Chat(_friends[index],_name[index])));
              },
              child: Container(
                height: MediaQuery.of(context).size.height/10,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${_name[index]}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.black54),),
                      Text("${_friends[index]}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,color: Colors.black54),),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      )
    );
  }
}
