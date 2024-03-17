import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Home.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email=new TextEditingController();
  TextEditingController _name=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;
  List _arr=[];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Help().then((List<dynamic> arr){
      setState(() {
        for(dynamic it in arr) _arr.add(it);
      });
    });
    super.initState();
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.cyan],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Register",style: TextStyle(fontSize: MediaQuery.of(context).size.height/10),),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.5,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white54,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87, width: 2.0),
                              ),labelText: "Email"),
                              style: TextStyle(color: Colors.black87),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _password,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87, width: 2.0),
                              ),labelText: "Password"),
                              style: TextStyle(color: Colors.black87),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the password';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _name,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87, width: 2.0),
                              ),labelText: "User Name"),
                              style: TextStyle(color: Colors.black87),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                          ),
                          ElevatedButton(onPressed: ()async{
                            if (_formKey.currentState!.validate()) {
                              final user= await _auth.createUserWithEmailAndPassword(email: _email.text.toString(), password: _password.text.toString());
                              String userid=_auth.currentUser!.uid.toString();
                              FirebaseDatabase ref=FirebaseDatabase.instance;
                              ref.ref(userid).set({
                                "Name": _name.text.toString(),
                                "Password": _password.text.toString(),
                                "email": _email.text.toString(),
                                "userid": userid
                              });
                              _arr.add(userid);
                              ref.ref("users").update({
                                "list":_arr
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()));
                            }
                          },
                            child: Text("Sign-Up",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30),),
                            style: ButtonStyle(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
