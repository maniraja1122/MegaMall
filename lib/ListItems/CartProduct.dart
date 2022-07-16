import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Repository/DBHelper.dart';
import 'package:megamall/Screens/CartItem.dart';

class CartProduct extends StatelessWidget {
  QueryDocumentSnapshot snap;
  QueryDocumentSnapshot cartitem;
  CartProduct({required this.cartitem,required this.snap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (dir) async {
        await cartitem.reference.delete();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      snap.get("imglink"),
                      height: 125,
                      width: 125,
                      fit: BoxFit.fill,
                    )),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(snap.get("Name"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(alignment: Alignment.topLeft,child: Text(r"$" + snap.get("Price").toString() + ".00",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snap.get("Type"),style: TextStyle(color: Colors.black54),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            constraints: BoxConstraints.tight(Size(36, 36)),
                            onPressed: () async {
                              if(cartitem.get("quantity")>1){
                                await cartitem.reference.update({
                                  "quantity":cartitem.get("quantity")-1
                                });
                              }
                            },
                            elevation: 2.0,
                            fillColor: Colors.grey,
                            child:Text("-",style: TextStyle(color: Colors.white,fontSize: 20),),
                            shape: CircleBorder(),
                          ),
                          Text(cartitem.get("quantity").toString()),
                          RawMaterialButton(
                            constraints: BoxConstraints.tight(Size(36, 36)),
                            onPressed: () async {
                              await cartitem.reference.update({
                                "quantity":cartitem.get("quantity")+1
                              });
                            },
                            elevation: 2.0,
                            fillColor: Colors.orange,
                            child: Icon(
                              Icons.add,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            shape: CircleBorder(),
                          )

                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
