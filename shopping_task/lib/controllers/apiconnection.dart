import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_task/constant.dart';
import 'package:shopping_task/models/product.dart';

        Future<List<ProductDetails>> apiconnection() async {
        final response = await http.get(
        Uri.parse('$dev/product/list'));
        if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) =>ProductDetails(
          pid:json['_id'],
        id: json['id'],
        title: json['title'],
        price: json['price'].toDouble(),
        description: json['description'],
        category:json['category'],
        image: json['image'],
        rate:json['rating']['rate'].toDouble(),
        count:json['rating']['count'],
      )).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

Future<String?> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString("token");
  return token;
}

Future<List<ProductDetails>> listcart() async {
  var token = await getToken();
  final response = await http.get(
    Uri.parse('$dev/cart/list'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },

  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) {
      final product = item['pid'];
      return ProductDetails(
        pid: product['_id'],
        id: product['id'],
        title: product['title'],
        price: product['price'].toDouble(),
        description: product['description'],
        category: product['category'],
        image: product['image'],
        rate: product['rating']['rate'].toDouble(),
        count: product['rating']['count'],
      );
    }).toList();
  }else {
       throw Exception('Failed to load products');
     }
  }


Future<List<ProductDetails>> listorder() async {
  var token = await getToken();
  final response = await http.get(
    Uri.parse('$dev/order/list'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },

  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((item) {
      final product = item['pid'];
      return ProductDetails(
        pid: product['_id'],
        id: product['id'],
        title: product['title'],
        price: product['price'].toDouble(),
        description: product['description'],
        category: product['category'],
        image: product['image'],
        rate: product['rating']['rate'].toDouble(),
        count: product['rating']['count'],
      );
    }).toList();
  }else {
    throw Exception('Failed to load products');
  }


}

