

import 'dart:developer';

import 'package:flutter/cupertino.dart';

class Cart extends ChangeNotifier{
  final List<CartProduct>_list =[];
  List<CartProduct>get getItems{
    return _list;
  }
  double get totalPrice{
    var total =0.0;
    for(var item in _list){
      total = total+(item.price*item.qty);
    }
    return total;
  }
  int? get count{
    return _list.length;
  }
  void addItem(
      int id,
      String name,
      double price,
      int qty,
      String imageurl,
      ){
    final product = CartProduct(
        id: id,
        name: name,
        price: price,
        qty: qty,
        imageurl: imageurl
    );
    _list.add(product);
    notifyListeners();
    log("add product!!!!");
  }
  void increment(CartProduct product){
    product.increase();
    notifyListeners();
  }
  void reduceByOne(CartProduct product){
    product.decrease();
    notifyListeners();
  }
  void removeItem(CartProduct product){
    _list.remove(product);
    notifyListeners();
  }
  void clearCart(){
    _list.clear();
    notifyListeners();
  }
}
class CartProduct{
  int id;
  String name;
  double price;
  int qty =1;
  String imageurl;
  CartProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.imageurl,
});
  factory CartProduct.fromJson(Map<String,dynamic>json)=>CartProduct(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      qty: json["qty"],
      imageurl: json["image"]
  );
  Map<String,dynamic>toJson()=>{
    "id":id,
    "name":name,
    "price":price,
    "qty":qty,
    "imageurl":imageurl,
  };
  void increase(){
    qty++;
  }
  void decrease(){
    qty--;
  }
}