 import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Home_Page.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:provider/provider.dart';
 import 'package:collection/collection.dart';
class DetailsPage extends StatelessWidget {
  String name,price,image,description;
  int id;
  DetailsPage({required this.id,
               required this.name,
               required this.description,
               required this.price,
               required this.image,
               });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                 children: [
                Container(
                  height: MediaQuery.of(context).size.width *0.8,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: NetworkImage(
                      image
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                    top: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new
                        ),
                        onPressed: () { 
                          Navigator.pop(context);
                        },
                      ),
                    )),
          ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 239, 240, 241),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 100),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 10),
                         child: Text(name,
                         style: TextStyle(
                           color: Colors.grey.shade600,
                           fontSize: 22,
                           fontWeight: FontWeight.bold,
                         ),),
                       ),
                       Text('Rs'+price,
                       style: TextStyle(
                         color: Colors.red.shade900,
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                       ),),
                       SizedBox(
                         height: 20,
                       ),
                       Text(description,
                       textScaleFactor: 1.1,
                       style: TextStyle(
                         fontSize: 15,
                         fontWeight: FontWeight.w400,
                         color: Colors.black,
                       ),
                         textAlign: TextAlign.start,
                       ),
                       SizedBox(
                         height: 10,
                       ),
                     ], 
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomSheet: Padding(
            padding: EdgeInsets.all(0.8),
            child: InkWell(
              onTap: (){
                log("price=="+double.parse(price).toString());

                var existingItemCart= context
                .read<Cart>().getItems.firstWhereOrNull((element)=>
                element.id==id);
                if(existingItemCart != null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                      content: Text("This is already in cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ));
                }else {
                  context
                      .read<Cart>().addItem(
                      id, name, double.parse(price), 1, image);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      content: Text("Added to cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ))
                  );

                }
              },
              child:Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: maincolor,
                ),
                child: Center(
                  child: Text("Add to Cart",
                  style: TextStyle(
                    fontSize: 20,color: Colors.white,
                  ),),
                ),
              ) ,
            ),
          ),
        )
    );
  }
}
