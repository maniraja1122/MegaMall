import 'package:flutter/material.dart';


class RatingShow extends StatelessWidget {
  double rating;
  RatingShow({required this.rating,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Icon(Icons.star,color: Colors.orange,),
          SizedBox(width: 2,),
          Text(rating.toStringAsFixed(1),style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    ),);
  }
}
