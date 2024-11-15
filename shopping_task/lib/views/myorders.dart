import 'package:flutter/material.dart';
import 'package:shopping_task/models/product.dart';
import 'package:shopping_task/controllers/apiconnection.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    super.initState();
    fetchorders();
  }

  List<ProductDetails> myorder=[];
  Future<void> fetchorders() async {
    try {
      List<ProductDetails> fetchedProducts = await listorder();
      setState(() {
        myorder = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.amber,
        title: const Text('MyOrders',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,
              color: Colors.black),),

      ),
      body: myorder.isEmpty
          ?  const Center(child:  Text('No orders')
      ): ListView.builder(
        itemCount: myorder.length,
        itemBuilder: (context, index) {
          final product = myorder[index];
          return ListTile(

            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text('\$${product.price}'),
          );
        },
      )
    );
  }
}
