import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/ListItems/ProductItem.dart';

import '../../Repository/DBHelper.dart';

class FavSection extends StatelessWidget {
  const FavSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: StreamBuilder(
        stream: DBHelper.db
            .collection("Favourite")
            .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            var arr = data!.docs.map((e) => e.get("productkey")).toList();
            if(arr.length>0){
            return ListView.builder(
              itemCount: arr.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: DBHelper.db
                      .collection("Product")
                      .where("key", isEqualTo: arr[index])
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if(snapshot.hasData){
                      return ProductItem(snap: snapshot.data!.docs[0]);
                    }
                    return SizedBox();
                  },
                );
              },
            );}
            else{
              return Text("No Favourites !",style: TextStyle(fontSize: 20),);
            }
          }
          return CircularProgressIndicator();
        },
      ),
    ));
  }
}
