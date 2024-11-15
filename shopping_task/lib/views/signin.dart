import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_task/constant.dart';
import 'package:shopping_task/views/homescreen.dart';
import 'package:shopping_task/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  FormPage createState() => FormPage();
}

class FormPage extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    return token;
  }

  Future<void> signin(String email, String password) async {
    try {
        Uri url = Uri.parse('$dev/login');
      var data = {
        "email": email,
        "password": password,
      };

      String? body = json.encode(data);

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in  Successfull...')));
        var token = response.headers['token'];
        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token);
           var tokenResponse = await getToken();

          if (tokenResponse != null) {
            Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        } else {
          print("Token not found in response headers.");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in failed')));
         }
    } catch (e) {
      print("login_error: $e");
    }
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Shopping',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
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
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailcontroller,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordcontroller,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        signin(_emailcontroller.text,_passwordcontroller.text);

                      },
                      child: const Text(
                        'Sign in',style: TextStyle(color: Colors.black,fontSize: 16),
                      ),
                    ),
                   const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const  Text("Don't have a account?"),
                       const  SizedBox(width:5),
                        Hero(
                          tag: 'dash',
                          child: TextButton(
                            child: const Text(
                              'Signup',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUp()),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
