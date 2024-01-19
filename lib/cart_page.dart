import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Provider/cart_provider.dart';
import 'package:my_ecommerce_app/checkout_page.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:provider/provider.dart';
class CartPage extends StatelessWidget {

List<CartProduct>cartlist=[];
  // const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
          color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Cart",style: TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),),
        actions: [
          context.watch<Cart>().getItems.isEmpty
          ?const SizedBox()
          :
          IconButton(onPressed: (){
            context.read<Cart>().clearCart();

          },
              icon: Icon(
                Icons.delete,
              ),
          )
        ],
      ),
      body:
          context.watch<Cart>().getItems.isEmpty
        ? Center(
            child: Text('Empty Cart'),
          )
          :
          Consumer<Cart>(builder:(context,cart,child) {
            cartlist = cart.getItems;
            return
              ListView.builder(
                  itemCount: cart.count,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          cartlist[index].imageurl,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(cartlist[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text("Rs."+cartlist[index].price.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade900,
                                                ),),
                                              Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius
                                                        .circular(15)
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          cartlist[index].qty==1?
                                                              cart.removeItem(
                                                                cart.getItems[
                                                                  index]):
                                                              cart.reduceByOne(
                                                                cartlist[index]);

                                                        },  icon: cartlist[index].qty==1?
                                                        Icon(Icons.delete,size: 18,
                                                        )
                                                        : Icon(
                                                      Icons.minimize_rounded,
                                                      size: 18,
                                                    )),
                                                    Text(cartlist[index].qty.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red
                                                            .shade900,
                                                      ),),
                                                    IconButton(
                                                        onPressed: () {
                                                          cart.increment(cartlist[index]);
                                                        }, icon: Icon(
                                                      Icons.add,
                                                      size: 18,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
          }
              ),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total :"+context.watch<Cart>().totalPrice.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),),
            InkWell(
              onTap: (){
                context.read<Cart>().getItems.isEmpty
                    ? ScaffoldMessenger.of(context).showSnackBar
                  (SnackBar( duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    content: Text("Cart is Empty",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                    ))
                : Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return CheckOutPage(cart: cartlist);
                    }));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: maincolor,
                ),
                child: Center(
                  child: Text("Order Now",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
