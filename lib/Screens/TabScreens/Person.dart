import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Repository/DBHelper.dart';
import 'package:megamall/Routes.dart';
import 'package:megamall/Screens/CompletedOrder.dart';
import 'package:megamall/Screens/RegisterProcess/Selector.dart';

class Person extends StatelessWidget {
  const Person({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.center,child: Text("Personal",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Our Mission",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Mega Mall offers a wide range of well-designed, functional home furnishing products at prices so low that as many people as possible will be able to afford them,also Build the best product, cause no unnecessary harm, use business to inspire and implement solutions to the environmental crisis.",style: TextStyle(fontSize: 20),),
          ),
          Divider(thickness: 5,),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: DBHelper.db
                    .collection("Users")
                    .where("key", isEqualTo: DBHelper.auth.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.hasData){
                    return ListTile(leading: Icon(Icons.verified_user,color: Colors.black,),title: Text(snapshot.data!.docs[0].get("Name"),style: TextStyle(fontWeight: FontWeight.bold),));
                  }
                  return CircularProgressIndicator();
                },
              ),
              Divider(thickness: 2,),
              InkWell(onTap: (){
                Navigator.pushNamed(context, Routes.CompletedOrder);
              },child: ListTile(leading: Icon(Icons.format_list_bulleted),title: Text("Completed Order Products"),)),
              Divider(thickness: 2,),
              InkWell(onTap: () async {
                await DBHelper.auth.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=>Selector()), (route) => false);
              },child: ListTile(leading: Icon(Icons.logout,color: Colors.red,),title: Text("Logout",style: TextStyle(color: Colors.red),),)),
              Divider(thickness: 2,)
            ],
          ),

        ],
      ),
    );
  }
}
