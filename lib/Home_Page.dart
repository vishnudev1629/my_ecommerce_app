import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Drawer.dart';
import 'package:my_ecommerce_app/Webservice/webservice.dart';
import 'package:my_ecommerce_app/category_productspage.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:my_ecommerce_app/details_page.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        backgroundColor: maincolor,
        title: Text("E-COMMERCE",style: TextStyle(
          fontWeight: FontWeight.bold,color: Colors.white,
        ),),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text("Category",style: TextStyle(
              fontSize: 20,
              color: maincolor,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 10,),
            FutureBuilder(
              future: Webservice().fetchCategory(),
              builder: (context,snapshot) {
                if(snapshot.hasData) {
                  return Container(
                    height: 80,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                log("clicked");

                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                      return CategoryProductsPage(
                                        catid: snapshot.data![index].id!,
                                        catname: snapshot.data! [index].category!,

                                      );
                                    }
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(37, 5, 2, 39),
                                ),
                                child: Center(
                                  child: Text(
                                  snapshot.data![index].category!,
                                    style: TextStyle(
                                      color: maincolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  );
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            ),
            SizedBox(height: 20,),
            Text("Most Searched Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: maincolor,
            ),),
            SizedBox(height: 10,),
            Expanded(
                child: FutureBuilder(
                  future: Webservice().fetchProducts(),
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {
                      log("product length ==" + snapshot.data!.length.toString());
                      return Container(
                        child: StaggeredGridView.countBuilder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              final product =snapshot.data![index];
                              return InkWell(
                                onTap: () {
                                  log("clicked");
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context){
                                        return DetailsPage(
                                            id: product.id!,
                                            name: product.productname!,
                                            description: product.description!,
                                            price: product.price.toString(),
                                            image:Webservice().imageurl+product.image!);
                                      }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                minHeight: 100, maxHeight: 250
                                            ),
                                            child: Image(
                                              image: NetworkImage(
                                                Webservice().imageurl+product.image!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: Text(product.productname!,
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey
                                                        .shade600,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight
                                                        .bold,
                                                  ),),
                                              ),
                                              Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Rs." + product.price.toString(),
                                                        style: TextStyle(
                                                          color: Colors.red
                                                              .shade900,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 17,
                                                        ),)
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            staggeredTileBuilder: (context) =>
                                StaggeredTile.fit(1)),
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}
