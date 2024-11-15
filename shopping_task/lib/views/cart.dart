import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_task/models/product.dart';
import 'package:shopping_task/controllers/apiconnection.dart';
import 'package:shopping_task/views/productsDetails.dart';
import '../constant.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});
  @override
  State<Cart> createState() => _CartState();
}
List<ProductDetails> cart=[];
class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<ProductDetails> fetchedProducts = await listcart();
      setState(() {
        cart = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    return token;
  }

  Future<void> placeorder(String pid) async {
    try {

      Uri url = Uri.parse('$dev/place/order');
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
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Placed Successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Placed Failed')));
      }

    } catch (e) {
      print("agent_error: $e");
    }

  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Cart',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
              color: Colors.black),),

      ),
      body: ListView.builder(
        itemCount:cart.length,
        itemBuilder: (context,index){
      final product = cart[index];
      return InkWell(
      //  onTap: (){Navigator.pop(context);},

        onTap: (){ Navigator.push(context, MaterialPageRoute(builder:
            (context)=>ProductsDetails(id: product.id,
            title: product.title, price: product.price,
            description: product.description,
            category: product.category, image: product.image,
            rate: product.rate, count: product.count,pid: product.pid,)));
            },
        child: ListTile(
          leading: Image.network(product.image, width: 50, height: 50),
          title: Text(product.title),
          subtitle: Row(
            children: [
              Text('\$${product.price.toStringAsFixed(2)}'),
              const SizedBox(width: 5),
              RichText(text: TextSpan(
                  children:[
                    const  WidgetSpan(
                        child:  Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        )),
                    TextSpan(
                        text: '${product.rate}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,color:Colors.black)),

                  ]
              )),
            ],
          ),
        trailing: TextButton(onPressed: (){
         placeorder(product.pid);

        }, child: const Text('PlaceOrder',style: TextStyle(color: Colors.black),)),

        ),
      );
        }

        
      ),
    );
  }
}
