import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/ListItems/CartProduct.dart';
import '../../Repository/DBHelper.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Flexible(
              child: Center(
      child: StreamBuilder(
              stream: DBHelper.db
                  .collection("Cart")
                  .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  var arr = snapshot.data!.docs;
                  if (arr.length > 0) {
                    return ListView.builder(
                      itemCount: arr.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StreamBuilder(
                          stream: DBHelper.db
                              .collection("Product")
                              .where(
                              "key", isEqualTo: arr[index].get("productkey"))
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                            if (snapshot.hasData) {
                              return CartProduct(cartitem: arr[index],
                                  snap: snapshot.data!.docs[0]);
                            }
                            return CircularProgressIndicator();
                          },
                        );
                      },
                    );
                  }
                  else{
                    return Text("Cart is Empty !",style: TextStyle(fontSize: 20),);
                  }
                }
                return CircularProgressIndicator();
              },
      ),
    ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",style: TextStyle(fontSize: 25),),
                    DBHelper().TotalCalculator
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              showDialog(context: context, builder: (c){
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Do you want to confirm this order?"),
                  actions: [
                    ElevatedButton(onPressed: () async {
                      await DBHelper.CompleteOrder();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your order will be delivered soon")));
                    }, child: Text("Yes")),
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("No")),
                  ],
                );
              });
            }, child: Text("Checkout"))
          ],
        ));
  }
}
