import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Home.dart';
import 'package:flutterchatapp/SignUp_page.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
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
                  Text("Login",style: TextStyle(fontSize: MediaQuery.of(context).size.height/10),),
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
                                if (value == null || value.length==0) {
                                  return 'Please enter the password';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height/50,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text("Don't have an account ? "),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));
                                    },
                                    child: Text("SignUp",style: TextStyle(color: Colors.blueAccent),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(onPressed: ()async{
                            if(_formKey.currentState!.validate()) {
                              try {
                                final user = await _auth
                                    .signInWithEmailAndPassword(
                                    email: _email.text.toString(),
                                    password: _password.text.toString());
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
                              }catch(e){
                                showModalBottomSheet(context: context, builder:(BuildContext context){
                                  return Container(
                                    height: 100,

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text("This email address donot exist or incorrect password entered",style: TextStyle(color: Colors.red),),
                                      ),
                                    ),
                                  );
                                });
                                _email.text="";
                                _password.text="";
                              }
                            }
                          },
                              child: Text("login",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30),),
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
