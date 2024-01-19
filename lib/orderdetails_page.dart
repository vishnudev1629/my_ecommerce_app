import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String? username;
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });
    log("isloggedin=" + username.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Order Details",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder(
          future: Webservice().fetchOrderDetails(username.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    log(snapshot.data!.length.toString());
                    final order_details = snapshot.data![index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                          elevation: 0,
                          color: Color.fromARGB(15, 74, 20, 140),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                              trailing: Icon(Icons.arrow_drop_down),
                              textColor: Colors.black,
                              collapsedTextColor: Colors.red,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    DateFormat.yMMMEd()
                                        .format(snapshot.data![index]!.date!),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    order_details.paymentmethod.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    order_details.totalamount.toString() + "/-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.red.shade900),
                                  ),
                                ],
                              ),
                              children: [
                                ListView.separated(
                                  itemCount: order_details!.products!.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 25),
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SizedBox(
                                        height: 100,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 100,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 9.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            Webservice()
                                                                    .imageurl +
                                                                order_details!
                                                                    .products![
                                                                        index]
                                                                    .image!
                                                                    .toString()),
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Wrap(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      order_details
                                                          .products![index]
                                                          .productname!
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade700),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          order_details
                                                              .products![index]
                                                              .price
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .red.shade900,
                                                          ),
                                                        ),
                                                        Text(
                                                          order_details!
                                                                  .products![
                                                                      index]
                                                                  .quantity
                                                                  .toString() +
                                                              "X ",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .green.shade900,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ])),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },

          //   }, {
          // return Center(child: CircularProgressIndicator(),);
          //
          //
          //     }),
        ));
  }
}
