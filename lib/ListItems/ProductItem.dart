import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Repository/DBHelper.dart';

class ProductItem extends StatelessWidget {
  QueryDocumentSnapshot snap;
  ProductItem({required this.snap, Key? key}) : super(key: key);

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
                    snap.get("imglink"),
                    height: 125,
                    width: 125,
                    fit: BoxFit.fill,
                  )),
              InkWell(
                onTap: () async {
                  await DBHelper.FavouriteThis(snap.get("key"));
                },
                child: StreamBuilder(
                  stream: DBHelper.db
                      .collection("Favourite")
                      .where("userkey", isEqualTo: DBHelper.auth.currentUser!.uid)
                      .where("productkey", isEqualTo: snap.get("key"))
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
                    child: Text(snap.get("Name"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 5,
                ),
                Text(
                  snap.get("description"),
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
                    Text(r"$" + snap.get("Price").toString() + ".00"),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Buy"),
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
