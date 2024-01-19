import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Home_Page.dart';
import 'package:my_ecommerce_app/Models/user_model.dart';
import 'package:my_ecommerce_app/Payment/razorpay.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:my_ecommerce_app/Webservice/webservice.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class CheckOutPage extends StatefulWidget {
  List<CartProduct> cart;
  CheckOutPage({required this.cart});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  int selectedValue =1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUsername();
  }
  String? username;
  void _loadUsername()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username=prefs.getString('username');
    });
    log("isloggedin ="+username.toString());
  }
  orderPlace(
      List<CartProduct>cart,
      String amount,
      String paymentmethod,
      String date,
      String name,
      String address,
      String phone,
      )async{
    print(
      "inside function"
    );
    String jsondata =jsonEncode(cart);
    log('jsondata=${jsondata}');
    final vm =Provider.of<Cart>(context,listen:false);
    final response=await http.post(Uri.parse(Webservice.mainurl+"order.php"),
      body: {
      "username":username,
        "amount":amount,
        "paymentmethod":paymentmethod,
        "date":date,
        "quantity":vm.count.toString(),
        "cart":jsondata,
        "name":name,
        "address":address,
        "phone":phone,
      }
    );
    if(response.statusCode==200){
      log(response.body);
      if(response.body.contains("Success")){
        vm.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            content: Text("YOUR ORDER SUCCESSFULLY COMPLETED",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),)));
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>
        HomePage()));
      }
    }
  }
   // var vm;
   String? name,address,phone;
   String? paymentmethod= "Cash on delivery";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed:() {
            Navigator.pop(context);
          },
        ),
        title: Text("CheckOut",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.black,
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<UserModel>(
                future: Webservice().fetchUser(username.toString()),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    name = snapshot.data!.name;
                    phone = snapshot.data!.phone;
                    address = snapshot.data!.address;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                                children: [
                                  Text("Name :", style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text(name.toString()),
                                ]
                            ),
                            SizedBox(height: 10,),
                            Row(
                                children: [
                                  Text("Phone :", style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text(phone.toString()),
                                ]
                            ),
                            SizedBox(height: 10,),
                            Row(
                                children: [
                                  Text("Address :", style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.5,
                                      child: Text(address.toString(),
                                        maxLines: 5,
                                      )),
                                ]
                            ),
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              ),
            ),
            SizedBox(height: 10,),
            RadioListTile(
              activeColor: maincolor,
                value: 1,
                groupValue: selectedValue,
                onChanged: (int? value){
                setState(() {
                  selectedValue=value!;
                  paymentmethod='Cash on delivery';
                });
                },
              title: Text("Cash On delivery"),
              subtitle: Text("Pay Cash At Home"),
                ),
            RadioListTile(
              activeColor: maincolor,
              value: 2,
              groupValue: selectedValue,
              onChanged: (int? value){
                setState(() {
                  selectedValue=value!;
                  paymentmethod='Online';
                });
              },
              title: Text("Pay Now"),
              subtitle: Text("Online Payment"),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: (){
              final vm =Provider.of<Cart>(context,listen:false);
               String datetime =  DateTime.now().toString();
               log(datetime.toString());
               log(name.toString());
               log(paymentmethod!);
               if(paymentmethod =="Online"){
                 Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>PaymentScreen(
                       cart: widget.cart,
                       amount: vm.totalPrice.toString(),
                       address: address.toString(),
                       paymentmethod: paymentmethod.toString(),
                       date: datetime.toString(),
                       name: name.toString(),
                       phone: phone.toString(),
                     )));
               }else if(paymentmethod == "Cash on delivery"){
                 log("cash on delivery section -------------------");
               orderPlace(widget.cart,vm.totalPrice.toString(),
                 paymentmethod!,datetime,name!,address!,phone!);
                   }
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: maincolor,
              ),
              child: Center(
                child: Text("Checkout",style: TextStyle(
                  fontSize: 20,color: Colors.white,
                ),),
              ),
            ),
        ),
      ),
    );
  }
}
