import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Models/Favourite.dart';
import 'package:megamall/Models/Product.dart';
import 'package:http/http.dart';
import 'package:megamall/Repository/AuthHelper.dart';
import 'dart:io';


class DBHelper {
  static var db = FirebaseFirestore.instance;
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;

  static Future<void> FavouriteThis(int key) async{
    var check=await db
        .collection("Favourite")
        .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
        .where("productkey", isEqualTo: key)
        .get();
    if(check.docs.length>0){
      await check.docs[0].reference.delete();
    }
    else{
      await DBHelper.db
          .collection("Favourite").add(Favourite(userkey: auth.currentUser!.uid, productkey: key).toMap());

    }
  }

}
