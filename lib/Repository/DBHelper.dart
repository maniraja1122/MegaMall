import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Models/Cart.dart';
import 'package:megamall/Models/Completed.dart';
import 'package:megamall/Models/Favourite.dart';
import 'package:megamall/Models/Product.dart';
import 'package:http/http.dart';
import 'package:megamall/Repository/AuthHelper.dart';
import 'dart:io';
import 'dart:developer' as dev;

class DBHelper {
  static var db = FirebaseFirestore.instance;
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;

  static Future<void> FavouriteThis(int key) async {
    var check = await db
        .collection("Favourite")
        .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
        .where("productkey", isEqualTo: key)
        .get();
    if (check.docs.length > 0) {
      await check.docs[0].reference.delete();
    } else {
      await DBHelper.db.collection("Favourite").add(
          Favourite(userkey: auth.currentUser!.uid, productkey: key).toMap());
    }
  }

  static Future<void> AddToCart(int price, int key, int count) async {
    var check = await db
        .collection("Cart")
        .where("userkey", isEqualTo: auth.currentUser!.uid)
        .where("productkey", isEqualTo: key)
        .get();
    if (check.docs.length > 0) {
      await check.docs[0].reference
          .update({"quantity": check.docs[0].get("quantity") + count});
    } else {
      await db.collection("Cart").add(Cart(
              Price: price,
              userkey: auth.currentUser!.uid,
              productkey: key,
              quantity: count)
          .toMap());
    }
  }

  StreamBuilder TotalCalculator = StreamBuilder(
    stream: DBHelper.db
        .collection("Cart")
        .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        num totalamount = 0;
        var arr = snapshot.data!.docs;
        for (var elements in arr) {
          totalamount += elements.get("quantity") * elements.get("Price");
          dev.log(totalamount.toString());
        }
        return Text(
          r"$" + "$totalamount",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        );
      }
      return CircularProgressIndicator();
    },
  );

  static Future<void> CompleteOrder() async {
    var arr = await db
        .collection("Cart")
        .where("userkey", isEqualTo: auth.currentUser!.uid)
        .get();
    arr.docs.forEach((element) async {
      await db.collection("Completed").add(Completed(
              userkey: element.get("userkey"),
              productkey: element.get("productkey"))
          .toMap());
      var prodlist=await db.collection("Product").where("key",isEqualTo: element.get("productkey")).get();
      await prodlist.docs[0].reference.update({
        "Total_Sells":element.get("quantity")+prodlist.docs[0].get("Total_Sells")
      });
      await element.reference.delete();
    });
  }
}
