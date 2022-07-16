import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:megamall/Widgets/RatingShow.dart';

import '../Repository/DBHelper.dart';

class CartItem extends StatefulWidget {
  QueryDocumentSnapshot product;
  CartItem({required this.product, Key? key}) : super(key: key);
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int count=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: [
                Image.network(widget.product.get("imglink")),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: Icon(
                              Icons.arrow_back,
                              size: 34,
                            ),
                          )),
                      InkWell(
                        onTap: () async {
                          await DBHelper.FavouriteThis(widget.product.get("key"));
                        },
                        child: StreamBuilder(
                          stream: DBHelper.db
                              .collection("Favourite")
                              .where("userkey",
                                  isEqualTo: DBHelper.auth.currentUser!.uid)
                              .where("productkey", isEqualTo: widget.product.get("key"))
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.length > 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.red,
                                        size: 34,
                                      )),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.black54,
                                        size: 34,
                                      )),
                                );
                              }
                            }
                            return SizedBox();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(widget.product.get("Name"),style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                          StreamBuilder(
                            stream: DBHelper.db
                                .collection("Review")
                                .where("productkey", isEqualTo: widget.product.get("key"))
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if(snapshot.hasData){
                                  var arr=snapshot.data!.docs;
                                  double sum=0;
                                  for(var elements in arr){
                                    sum+=elements.get("Rating");
                                  }
                                  if(arr.length==0){
                                    return RatingShow(rating: 0);
                                  }
                                  else{
                                    return RatingShow(rating: sum/arr.length);
                                  }
                              }
                              return RatingShow(rating: 0);
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10,)
                      ,Text(widget.product.get("description"),maxLines: 3,overflow: TextOverflow.ellipsis  ,),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonBar(
                            alignment:MainAxisAlignment.center ,
                            children: [
                                  InkWell(onTap: (){setState((){if(count>1){
                                    count--;
                                  }
    });}, child: Text("-",style: TextStyle(fontSize: 40),)),
                                  Text("$count",style: TextStyle(fontSize: 20)),
                                  InkWell(onTap: (){setState((){count++;
                                  });},  child: Text("+",style: TextStyle(fontSize: 40))),
                            ],
                          ),
                          Text("${widget.product.get("Total_Sells")} Total Sales")
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r"$"+widget.product.get("Price").toString()+".00",style: TextStyle(fontSize: 25,color: Colors.green,fontWeight: FontWeight.bold),),
                          ElevatedButton(onPressed: () async {
                           await DBHelper.AddToCart(widget.product.get("Price"),widget.product.get("key"), count);
                           Navigator.pop(context);
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Added to Cart Successfully")));
                          }, child: Text("Buy Now"),style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                          ),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
