

import 'dart:convert';
 import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_ecommerce_app/Models/category_model.dart';
import 'package:my_ecommerce_app/Models/orderdetails_model.dart';
import 'package:my_ecommerce_app/Models/product_model.dart';
import 'package:my_ecommerce_app/Models/user_model.dart';


class Webservice{
  final imageurl = "http://bootcamp.cyralearnings.com/products/";
  static final mainurl ="http://bootcamp.cyralearnings.com/";

  Future<List<ProductModel>>fetchProducts()async{
    final response =await http.get(
      Uri.parse( mainurl+'view_offerproducts.php')
    );
    if(response.statusCode ==200){
      final parsed =json.decode(response.body).cast<Map<String,dynamic>>();
      return parsed
          .map<ProductModel>((json)=>ProductModel.fromJson(json)).toList();
    }else{
      throw Exception("failed to load products");
    }
  }
  Future<List<ProductModel>>fetchCatProducts(int catid)async{
    log("catid=="+ catid.toString());
    final response =await http.post(
        Uri.parse( mainurl+'get_category_products.php'),
      body: {'catid':catid.toString()},
    );
    log("statuscode=="+ response.statusCode.toString());
    if(response.statusCode ==200){
      log("catid in string"); 
      log("response=="+response.body.toString());
      final parsed =json.decode(response.body).cast<Map<String,dynamic>>();
      return parsed
          .map<ProductModel>((json)=>ProductModel.fromJson(json)).toList();
    }else{
      throw Exception("failed to load products");
    }
  }
  Future<List<OrderModel>?>fetchOrderDetails(String username)async{
    try {
      log("username ==" + username.toString());
      final response = await http.post(Uri.parse(
          mainurl + 'get_orderdetails.php'),
          body: {'username': username.toString()});
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load order details');
      }
    }catch(e){
      log(e.toString());
    }
  }
  Future<List<CategoryModel>?>fetchCategory()async{
    final response=await http.get(
      Uri.parse("http://bootcamp.cyralearnings.com/getcategories.php")
    );
    if (response.statusCode == 200){
      final parsed =json.decode(response.body).cast<Map<String,dynamic>>();
      return parsed
          .map<CategoryModel>((json)=>CategoryModel.fromJson(json)).toList();
    }else{
      throw Exception('failed to load cateogory');
    }
  }
  Future<UserModel>fetchUser(String username)async{
    final response=await http.post(Uri.parse(mainurl+'get_user.php'),
    body: {'username':username});
    if(response.statusCode==200){
      return UserModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load fetchUser');
    }
  }
}
