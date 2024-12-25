import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'cart.dart';



class ProductsDetails extends StatefulWidget {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;
  final String pid;

  const ProductsDetails({super.key, required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  required this.pid});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {

  @override
  void initState() {
    super.initState();

  }
  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    return token;
  }

  Future<void> addcart(String pid) async {
    try {
       Uri url = Uri.parse('$dev/cart/add');
       var data = {
         "pid": pid,
       };

       String? body = json.encode(data);
       var token = await getToken();
            var response = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token',
              },
              body: body,
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cart added Successfully')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cart added Failed')));
            }
          } catch (e) {
            print("agent_error: $e");
          }
        }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('${widget.category}',style: const TextStyle(color: Colors.black),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));

          }, icon:const  Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${widget.title}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing:  RichText(text: TextSpan(
                  children:[
                    const  WidgetSpan(
                        child:  Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        )),
                    TextSpan(
                        text: '${widget.rate}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,color:Colors.black)),
                  ]
              )),
            ),
            Container(
              child: Image.network(widget.image, width: 200, height: 200),
            ),
            ListTile(
              title: Text(
                '${widget.description}',
                style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text('\$${widget.price}',style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 25),),
            subtitle: Text('Stocks Availble ${widget.count}',style: const TextStyle(color: Colors.red),),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            addcart(widget.pid);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: const Text(
                 'Add to Cart',
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ),
      ),

    );
  }
}

