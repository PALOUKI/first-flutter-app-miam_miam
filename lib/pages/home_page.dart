import 'package:flutter/material.dart';

import 'home_page_food.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            title: Container(
              margin: const EdgeInsets.only(left: 50),
              child:  const Row(
                children: [
                  Text("miam",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 33
                    ),
                  ),
                  Text("_miam",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w800,
                        fontSize: 33
                    ),
                  ),
                ],
              )
            ),
            bottom: const TabBar(
              tabs:  [
                Tab(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu, color: Colors.white),
                          Text("nourritures", style: TextStyle(color: Colors.white),)
                        ]
                    )
                ),
                Tab(
                    icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          Text("else")
                        ]
                    )
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              HomePageFood(),
              Center(child: Text("Page 2")),
            ],
          ),
        ),
    );
  }
}
