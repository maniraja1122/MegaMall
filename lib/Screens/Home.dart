import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:megamall/Screens/TabScreens/Cart.dart';
import 'package:megamall/Screens/TabScreens/FavSection.dart';
import 'package:megamall/Screens/TabScreens/HomeFeed.dart';

import 'TabScreens/Person.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 4, child: Scaffold(
      body: TabBarView(children: [
          HomeFeed(),CartScreen(),FavSection(),Person()
      ],),
      bottomNavigationBar: TabBar(indicatorWeight: 5,labelColor: Colors.blue,unselectedLabelColor: Colors.grey,tabs: [
        Tab(icon: Icon(Icons.home_filled),),
        Tab(icon: Icon(Icons.shopping_cart),),
        Tab(icon: Icon(Icons.favorite),),
        Tab(icon: Icon(Icons.person),),
      ],),
    ));
  }
}
