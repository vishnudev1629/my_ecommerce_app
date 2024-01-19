import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Login_Page.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers:[
    ChangeNotifierProvider(create:(_)=>Cart()),
  ], child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
