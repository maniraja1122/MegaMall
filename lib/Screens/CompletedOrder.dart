import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/ListItems/ReviewProductItem.dart';
import 'package:megamall/Repository/AuthHelper.dart';
import 'package:megamall/Repository/DBHelper.dart';

class CompletedOrder extends StatelessWidget {
  const CompletedOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Order List"),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: DBHelper.db
              .collection("Completed")
              .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              if (data.length > 0) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StreamBuilder(
                      stream: DBHelper.db
                          .collection("Product")
                          .where("key",
                              isEqualTo: data[index].get("productkey"))
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if(snapshot.hasData){
                          return ReviewProductItem(snap: snapshot.data!.docs[0],completed: data[index],);
                        }
                        return SizedBox();
                      },
                    );
                  },
                );
              } else {
                return Text(
                  "No Completed Orders Yet",
                  style: TextStyle(fontSize: 22),
                );
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
