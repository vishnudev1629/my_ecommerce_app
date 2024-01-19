import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Webservice/webservice.dart';
import 'package:my_ecommerce_app/details_page.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
class CategoryProductsPage extends StatefulWidget {
  // const CategoryProductsPage({super.key});
String catname;
int catid;
CategoryProductsPage({required this.catid,required this.catname});
  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.catname,
          style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),),
      ),
      body: FutureBuilder(
        future: Webservice().fetchCatProducts(widget.catid),
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            return StaggeredGridView.countBuilder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
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
                                image: Webservice().imageurl+product.image!);
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
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 100, maxHeight: 250,
                                ),
                                child: Image(
                                  image: NetworkImage(
                                    Webservice().imageurl + product.image!,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(product.productname!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                  ),
                                  Column(
                                    children: [
                                      Text("Rs." + product.price.toString(),
                                        style: TextStyle(
                                          color: Colors.red.shade900,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),)
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
                    StaggeredTile.fit(1));
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
