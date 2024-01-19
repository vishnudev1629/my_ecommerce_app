import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Home_Page.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:my_ecommerce_app/Webservice/webservice.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  List<CartProduct> cart;
  String amount;
  String paymentmethod;
  String date;
  String name;
  String address;
  String phone;
  PaymentScreen(
      {required this.address,
        required this.amount,
        required this.cart,
        required this.date,
        required this.name,
        required this.paymentmethod,
        required this.phone});
  @override
  _paymentseciton createState() => _paymentseciton();
}

class _paymentseciton extends State<PaymentScreen> {
  Razorpay? razorpay;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    flutterpayment("abcd", 10);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay!.clear();
  }

  String? username;

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });
    log("isloggedin = " + username.toString());
  }

  orderPlace(
      List<CartProduct> cart,
      String amount,
      String paymentmethod,
      String date,
      String name,
      String address,
      String phone,
      ) async {
    try {
      String jsondata = jsonEncode(cart);
      log('jsondata =${jsondata}');

      final vm = Provider.of<Cart>(context, listen: false);

      final response = await http.post(
          Uri.parse(Webservice.mainurl + "order.php"
            // Webservice.mainurl1 + "order.jsp"
          ),
          body: {
            "username": username,
            "amount": amount,
            "paymentmethod": paymentmethod,
            "date": date,
            "quantity": vm.count.toString(),
            "cart": jsondata,
            'name': name,
            "address": address,
            "phone": phone,
          });

      if (response.statusCode == 200) {
        log(response.body);
        if (response.body.contains("Success")) {
          vm.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Text("YOUR ORDER SUCCESSFULLY COMPLETED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
          ));
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void flutterpayment(String orderId, int t) {
    var options = {
      "key": "rzp_test_QyVDkNwzUcW5LC",
      "amount": t * 100,
      'name': 'ghgjjg',
      'currency': 'INR',
      'description': 'maligai',
      'external': {
        'wallets': ['paytm']
      },
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "prefill": {"contact": "9744765904", "email": "vishnucherupuzha2020@gmail.com"},
    };
    try {
      razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    response.orderId;

    sucessmethd(response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("error==${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("waleeetttttt==");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }

  void sucessmethd(String paymentid) {
    log("sucess==" + paymentid);
    orderPlace(widget.cart, widget.amount.toString(), widget.paymentmethod,
        widget.date, widget.name, widget.address, widget.phone);
  }
}





// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:my_ecommerce_app/Home_Page.dart';
// import 'package:my_ecommerce_app/Provider/cart_provider.dart';
// import 'package:my_ecommerce_app/Webservice/webservice.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// class PaymentScreen extends StatefulWidget {
//   List<CartProduct>cart;
//   String amount;
//   String paymentmethod;
//   String date;
//   String name;
//   String address;
//   String phone;
//
//    PaymentScreen({
//     required this.address,
//     required this.name,
//     required this.phone,
//     required this.cart,
//     required this.amount,
//     required this.date,
//     required this.paymentmethod});
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
// class _PaymentScreenState extends State<PaymentScreen> {
//   Razorpay? razorpay;
//   TextEditingController textEditingController = new TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadUsername();
//     razorpay =Razorpay();
//     razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
//     razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
//     razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
//     flutterpayment("abcd",10);
//   }
//   @override
//   void dispose(){
//     super.dispose();
//     razorpay!.clear();
//   }
//   String? username;
//
//   void _loadUsername()async{
//     final prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       username=prefs.getString('uaername');
//     });
//     log("isloggedin ="+username.toString());
//   }
//   orderPlace(
//       List<CartProduct>cart,
//       String amount,
//       String paymentmethod,
//       String date,
//       String name,
//       String address,
//       String phone,
//       )async{
//     try{
//       String jsondata=jsonEncode(cart);
//       log("jsondata =${jsondata}");
//
//       final vm=Provider.of<Cart>(context,listen: false);
//
//       final response = await http.post(
//         Uri.parse(Webservice.mainurl+"order.php"),
//         body: {
//           "username":username,
//           "amount":amount,
//           "paymentmethod":paymentmethod,
//           "quantity":vm.count.toString(),
//           "caet":cart,
//           "name":name,
//           "address":address,
//           "phone":phone,
//         }
//       );
//       if(response.statusCode==200){
//         log(response.body);
//         if(response.body.contains("Success")){
//           vm.clearCart();
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               duration: Duration(seconds: 3),
//               behavior: SnackBarBehavior.floating,
//               padding: EdgeInsets.all(15),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10))
//               ),
//               content: Text("YOUR ORDER SUCCESSFULLY COMPLETED",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),)));
//           Navigator.push(context, MaterialPageRoute(
//               builder: (context)=>
//                   HomePage()));
//         }
//       }
//         }catch(e){
//       log(e.toString());
//       }
//     }
//   void flutterpayment(String orderId,int t){
//     var options={
//       "key":"rzp_test_QyVDkNwzUcW5LC",
//       "amount":t*100,
//       "name":"abcde",
//       "currency":"INR",
//       "description":"Null",
//       "external":{
//         'wallets':['paytm']
//       },
//       'retry':{'enabled':true,'max_count':1},
//       'send_sms_hash':true,
//       'prefill':{"contact":"9744765904","email":"vishnucherupuzha2020@gmail.com"},
//     };
//     try{
//       var razorpay;
//       razorpay!.open(options);
//     }catch(e){
//       debugPrint('Error: e');
//     }
//   }
//   void _handlePaymentSuccess(PaymentSuccessResponse response){
//     response.orderId;
//     sucessmethd(response.paymentId.toString());
//   }
//   void _handlePaymentError(PaymentFailureResponse response){
//     log("error=="+response.message.toString());
//   }
//   void _handleExternalWallet(ExternalWalletResponse response){
//     log("walettttttttttttttt");
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(),
//     );
//   }
//   void sucessmethd(String paymentid){
//     log("success=="+paymentid);
//     orderPlace(widget.cart,widget.amount.toString(),widget.paymentmethod,
//     widget.date,widget.name,widget.address,widget.phone);
//   }
// }
