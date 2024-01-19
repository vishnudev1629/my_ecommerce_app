import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Home_Page.dart';
import 'package:my_ecommerce_app/Login_Page.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:my_ecommerce_app/cart_page.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:my_ecommerce_app/orderdetails_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 50,),
            Align(
              alignment: Alignment.center,
              child: Text("E-COMMERCE",style: TextStyle(
                color: maincolor,fontWeight: FontWeight.bold,fontSize: 20,
              ),),
            ),
            Divider(),
            SizedBox(height: 10,),
             ListTile(
               leading: Icon(Icons.home),
               title: Text("Home",style: TextStyle(
                 fontSize: 15
               ),),
               trailing: Icon(Icons.keyboard_arrow_right),
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>HomePage()));
               },
             ),
            ListTile(
              leading: badges.Badge(
                showBadge:context.read<Cart>().getItems.isEmpty?false:true,
                  badgeStyle:badges.BadgeStyle(badgeColor: Colors.red),
                  badgeContent:Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
                  ),
                  child: Icon(Icons.shopping_cart)),
              title: Text("Cart Page",style: TextStyle(
                  fontSize: 15
              ),),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>CartPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book_online),
              title: Text("Order Details",style: TextStyle(
                  fontSize: 15
              ),),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>
                OrderDetailsPage()));

              },
            ),
            Divider(),
        ListTile(
          leading: Icon(Icons.power_settings_new,color: Colors.red,),
          title: Text("Logout",style: TextStyle(
              fontSize: 15
          ),),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: ()async{
            final prefs =await SharedPreferences.getInstance();
            prefs.setBool("isLoggedIn",false);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>LoginPage()));
          },
        ),
          ],
        ),
      ),
    );
  }
}
