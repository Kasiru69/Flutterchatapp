import 'dart:io';
import 'dart:math';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class Chat extends StatefulWidget {
  final String okid,name;

  const Chat(this.okid,this.name, {Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String _okid="",_roomid="",_userid="",_okname="";
  FirebaseAuth _auth=FirebaseAuth.instance;
  List _chats=[];
  List _user1=[];
  List _user2=[];
  List _sender=[];
  List _name=[];
  bool _socketConnected=false;
  late io.Socket socket;
  @override
  void initState() {
    setState(() {
      _okid=widget.okid;
      _okname=widget.name;
      print(_okname);
      _userid=_auth.currentUser!.uid;
      _roomid=concatenateLexicographically(_okid,_userid);
    });
    //socket = io.io('http://192.168.0.105:5001');
    setState(() {
      socket = io.io('http://192.168.0.105:5001', <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      });
      socket.connect();
    });
    //socket.connect();
    socket.onConnect((_) {
      print('Connected to the socket server');
    });
    socket.on('chat_message', (data) {
      print("message got");
      setState(() {
       if(data[2]==_roomid){
         print(_roomid);
         if(data[1]!=_userid){
           _chats.add(data[0]);
           _sender.add(data[1]);
           print("${data[0]} ${_userid}");
           help(data[1]);
         }
       }
      });
    });
    //socket = io.io('http://192.168.0.105:5001');
    //socket.connect();
    Help().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) _chats.add(it);
      });
      print(_chats);
    });
    Help1().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) _user1.add(it);
      });
      print(_user1);
    });
    Help2().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) _user2.add(it);
      });
      print(_user2);
    });
    Help3().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) { _sender.add(it); help(it); }
      });
      print(_sender);
    });
    super.initState();
  }
  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
  Future<List<dynamic>> Help1()async{
    List<dynamic> arr=[];
    print(_userid);
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
  Future<List<dynamic>> Help2()async{
    List<dynamic> arr=[];
    print(_okid);
    final ref=FirebaseDatabase.instance.ref(_okid).child("friend");
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
  Future<List<dynamic>> Help3()async{
    List<dynamic> arr=[];
    print(_roomid);
    final ref=FirebaseDatabase.instance.ref(_roomid).child("sender");
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
  Future<List<dynamic>> Help()async{
    List<dynamic> arr=[];
    print(_roomid);
    final ref=FirebaseDatabase.instance.ref(_roomid).child("list");
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
  String concatenateLexicographically(String a, String b) {
      if (a.compareTo(b) <= 0)
      return a + b;
      else
      return b + a;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController text=new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("${_okname}"),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/1.2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white54,
                child: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 0)),
                  builder: (context, snapshot) {
                    return ListView.builder(itemCount:_name.length,itemBuilder: (BuildContext context,int index){

                      return (_sender.length>0)?Container(
                        child: Row(
                          mainAxisAlignment: (_sender[_sender.length-index-1]==_userid)?MainAxisAlignment.end:MainAxisAlignment.start,
                          children: [
                            (_sender[_sender.length-index-1]==_userid)?Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width/3,),
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      color: Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${_name[_name.length-index-1]}",style: TextStyle(color: Colors.black54),),
                                            Text("${_chats[_chats.length-index-1]}",style: TextStyle(color: Colors.black54,fontSize: 20),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ):
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width/1.6,
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${_name[_sender.length-index-1]}",style: TextStyle(color: Colors.black54),),
                                              Text("${_chats[_sender.length-index-1]}",style: TextStyle(color: Colors.black54,fontSize: 20),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/3,),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ):Container();
                    },
                        reverse: true,
                      controller:ScrollController(initialScrollOffset: 10.0,));
                  }
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/1.2-80,
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: text,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: ()async{
                        //print("${text.text.toString()}");
                        String str=text.text.toString();
                        FirebaseDatabase ref=FirebaseDatabase.instance;
                        if(str.length>0){
                          //socket = io.io('http://192.168.0.105:5001');
                          //socket.connect();
                          List temp=[];
                          temp.add(str); temp.add(_userid); temp.add(_roomid);
                          socket.emit("chat_message",temp);
                          _chats.add(str);
                          _sender.add(_userid);
                          help(_userid);
                          ref.ref(_roomid).update({
                            "list":_chats,
                            "sender":_sender
                          });
                          if(!_user1.contains(_okid)) {
                            _user1.add(_okid);
                            ref.ref(_userid).update({
                              "friend": _user1
                            });
                          }
                          if(!_user2.contains(_userid)) {
                            _user2.add(_userid);
                            ref.ref(_okid).update({
                              "friend": _user2
                            });
                          }
                        }
                        text.text="";
                      },
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),hintText: "Enter your text",
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
