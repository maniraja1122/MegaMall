import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megamall/ListItems/ProductItem.dart';

import '../../Repository/DBHelper.dart';
import 'dart:developer' as dev;
class HomeFeed extends StatefulWidget {
  HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  var searchedterm="";
  var Selected = "All";
  var maxlimit=201.0;
  var popularity="No";
  List sortoptions=["Ascending","Descending","No"];
  List arr = ["All", "Chair", "Table", "Lamp", "Floor", "Bed", "Cupboard"];
  var mystream=DBHelper.db.collection("Product").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (val){searchedterm=val;setState((){});},
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search here",
                    prefixIcon: Icon(Icons.search),
                    suffix: InkWell(
                        onTap: (){
                          showModalBottomSheet(enableDrag: false,isDismissible: false,context: context, builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setStatebs) {
                              return Container(
                                height: 400,
                                child: Card(elevation: 10,shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                              ),
                                  child:
                                  Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Text("Sort by Prices",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10,),
                                      ButtonBar(
                                        alignment:MainAxisAlignment.center ,
                                        children: [
                                       for(var options in sortoptions) ElevatedButton(
                                           onPressed: (){popularity=options;setStatebs((){});}, child: Text(options),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(popularity==options?Colors.blue:Colors.grey)),)
                                        ],
                                      ),
                                      SizedBox(height: 50,),
                                      Text("Max Price Rate",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                      Slider(divisions: 101,label:r"$"+maxlimit.toInt().toString(),max: 201,min: 99,value:maxlimit, onChanged: (c){
                                        setStatebs((){
                                          maxlimit=c;
                                        });
                                      }),
                                      SizedBox(height: 50,),
                                      ElevatedButton(onPressed: (){Navigator.pop(context);
                                      updatestream();
                                      setState((){});}, child: Text("Apply Filters"))
                                    ],
                                  ),
                                ),
                              );
                          });
                          },);
                        },
                        child: Icon(Icons.filter_alt_sharp))
                ),
              ),
              Wrap(
                spacing: 10,
                children: [
                  for (int i = 0; i < arr.length; i++)
                    ChoiceChip(
                      label: Text(
                        arr[i],
                        style: TextStyle(
                            color: arr[i] == Selected
                                ? Colors.white
                                : Colors.black),
                      ),
                      selected: arr[i] == Selected,
                      onSelected: (val) {
                        setState(() {Selected = arr[i];updatestream();});
                      },
                      selectedColor: Colors.blue,
                      backgroundColor: Theme.of(context).backgroundColor,
                      elevation: 4,
                    )
                ],
              ),
              Flexible(
                child: StreamBuilder(stream:mystream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.hasError){
                    dev.log(snapshot.error.toString());
                    return Center(child: Text("Error"),);
                  }
                  else if(snapshot.hasData){
                    var data=snapshot.data;
                    var arr=data!.docs.where((e) => e.get("Name").toString().toLowerCase().contains(searchedterm.toLowerCase())).toList();
                    if(arr.length>0) {
                      return ListView.builder(itemCount: arr.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductItem(snap: arr[index]);
                        },);
                    }
                    else{
                      return Center(child: Text("No Search Result Found",style: TextStyle(fontSize: 20),));
                    }
                  }
                  return Center(child: CircularProgressIndicator(),);
                }, ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void updatestream(){
    switch(Selected){
      case "All":
        switch(popularity){
          case "Ascending":
            mystream=DBHelper.db.collection("Product").where("Price",isLessThanOrEqualTo: maxlimit).orderBy("Price").snapshots();
            break;
          case "Descending":
            mystream=DBHelper.db.collection("Product").where("Price",isLessThanOrEqualTo: maxlimit).orderBy("Price",descending: true).snapshots();
            break;
          case "No":
            mystream=DBHelper.db.collection("Product").where("Price",isLessThanOrEqualTo: maxlimit).snapshots();
            break;
        }
        break;
      default:
        switch(popularity){
          case "Ascending":
            mystream=DBHelper.db.collection("Product").where("Type",isEqualTo: Selected).where("Price",isLessThanOrEqualTo: maxlimit).orderBy("Price").snapshots();
            break;
          case "Descending":
            mystream=DBHelper.db.collection("Product").where("Type",isEqualTo: Selected).where("Price",isLessThanOrEqualTo: maxlimit).orderBy("Price",descending: true).snapshots();
            break;
          case "No":
            mystream=DBHelper.db.collection("Product").where("Type",isEqualTo: Selected).where("Price",isLessThanOrEqualTo: maxlimit).snapshots();
            break;
        }
        break;
    }
  }
}
