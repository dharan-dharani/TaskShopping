import 'package:flutter/material.dart';
import 'package:shoppings/views/signin.dart';

import '../controllers/apiconnection.dart';
import '../models/product.dart';
import 'cart.dart';
import 'myorders.dart';
import 'productsDetails.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<ProductDetails> products=[];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    try {
      List<ProductDetails> fetchedProducts = await apiconnection();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Products',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
                color: Colors.black),),
      actions: [
        IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const MyOrders()));


        }, icon: const Icon(Icons.local_shipping_sharp)),


        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));

        }, icon:const  Icon(Icons.shopping_cart)), IconButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const Login()));


        }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: products.isEmpty
          ? const Center(child:  CircularProgressIndicator()):
      ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:
                  (context)=>ProductsDetails(id: product.id,
                      title: product.title, price: product.price,
                      description: product.description,
                      category: product.category, image: product.image,
                      rate: product.rate, count: product.count,pid: product.pid,)));
            },
            child: ListTile(

              leading: Image.network(product.image,width: 50,height: 50,),
              title: Text(product.title),

              subtitle: Text(product.category),
              trailing: RichText(text: TextSpan(
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
            ),
          );
        },
      )
    );
  }
}
