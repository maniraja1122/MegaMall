import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:megamall/Models/Review.dart';
import 'package:megamall/Repository/DBHelper.dart';


class ReviewProductItem extends StatefulWidget {
  QueryDocumentSnapshot snap;
  QueryDocumentSnapshot completed;
  ReviewProductItem({required this.completed,required this.snap, Key? key}) : super(key: key);

  @override
  State<ReviewProductItem> createState() => _ReviewProductItemState();
}

class _ReviewProductItemState extends State<ReviewProductItem> {
  var myrating=0.0;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    widget.snap.get("imglink"),
                    height: 125,
                    width: 125,
                    fit: BoxFit.fill,
                  )),
              InkWell(
                onTap: () async {
                  await DBHelper.FavouriteThis(widget.snap.get("key"));
                },
                child: StreamBuilder(
                  stream: DBHelper.db
                      .collection("Favourite")
                      .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
                      .where("productkey", isEqualTo: widget.snap.get("key"))
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
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.snap.get("Name"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.snap.get("description"),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r"$" + widget.snap.get("Price").toString() + ".00"),
                    widget.completed.get("reviewed")?SizedBox():ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: (c){
                          return AlertDialog(title: Text("Review",style: TextStyle(fontWeight: FontWeight.bold),),content: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              myrating=rating;
                            },
                          ),actions:[
                            ElevatedButton(onPressed: () async {
                              await widget.completed.reference.update({
                                "reviewed":true
                              });
                              await DBHelper.db.collection("Review").add(Review(userkey: widget.completed.get("userkey"), productkey:widget.completed.get("productkey") , Rating: myrating).toMap());
                              myrating=1;
                              Navigator.pop(context);
                            }, child: Text("Rate it !")),
                            ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Cancel")),
                          ],);
                        });
                      },
                      child: Text("Review"),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
