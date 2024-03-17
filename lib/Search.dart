import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Chat.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List _list=[];
  List _name=[];
  FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController search=new TextEditingController();
  String _userid="";
  @override
  void initState() {
    setState(() {
      _userid=_auth.currentUser!.uid;
    });
    Help().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr)
          if(it!=_userid){
            _list.add(it);
            String s="";
            help(it);
          }
        print(_list);
      });
    });
    super.initState();
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
  Future<List<dynamic>> Help()async{
    List<dynamic> arr=[];
    final ref=FirebaseDatabase.instance.ref("users").child("list");
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: TextField(
          controller: search,
          decoration: InputDecoration(hintText: 'Search for a user',
            suffixIcon: IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white54],
          ),
        ),
        child: ListView.builder(itemCount:_name.length,itemBuilder: (BuildContext context,int index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Chat(_list[index],_name[index])));
              },
              child: Container(
                height: MediaQuery.of(context).size.height/10,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${_name[index]}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.black54),),
                      Text("${_list[index]}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,color: Colors.black54),),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
