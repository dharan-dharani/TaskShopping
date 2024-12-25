import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constant.dart';
import 'signin.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  Signup createState() => Signup();
}

class Signup extends State<SignUp> {
  final _checker = GlobalKey<FormState>();
  final TextEditingController _fcontroller = TextEditingController();
   final TextEditingController _econtroller = TextEditingController();
  final TextEditingController _pcontroller = TextEditingController();

  Future<void> signup(String name, String email, String password) async {

    try {
      Uri url = Uri.parse('$dev/register');
      var data = {
        "name": name,
        "email": email,
        "password": password,
      };
      String? body = json.encode(data);
      var response = await http.post(url,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },

        body: body,
      );

 if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up Sucessfull')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed')));
      }
    } catch (e) {
      print("agent_error: $e");
    }
  }
  @override
  void dispose() {
    _fcontroller.dispose();
    _econtroller.dispose();
    _pcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Shopping', style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding:const  EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.amber,Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

              ),
              borderRadius: BorderRadius.circular(15),

            ),
            height: 450,
            width: 300,
            child: Form(
              key: _checker,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _fcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          label: const Text(
                            'UserName',
                          ),
                          prefixIcon:const Icon(Icons.person),
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(15))),
                    ),
                    const SizedBox(height: 20),
                
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your EmailAddress";
                        }
                        return null;
                      },
                      controller: _econtroller,
                      decoration: InputDecoration(
                          label: const Text(
                            'Email',
                          ),
                          prefixIcon: const Icon(Icons.email),
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(15))),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your Password";
                        }
                        return null;
                      },
                      controller: _pcontroller,
                      decoration: InputDecoration(
                          label: const Text(
                            'Password',
                          ),
                          prefixIcon: const Icon(Icons.password),
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(15))),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        signup(_fcontroller.text,_econtroller.text,_pcontroller.text);
                      },
                      child: const Text(
                        'Sign up',style: TextStyle(color: Colors.black,fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Hero(
                      tag: 'dash',
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text('Back to login Page')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
    }

