import 'package:flutter/material.dart';
import 'package:coffee_roast/tabs/roast.dart';
import 'package:coffee_roast/tabs/info.dart';
import 'package:coffee_roast/tabs/settings.dart';
import 'package:coffee_roast/tabs/recipes.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(title: "Coffee Roast", home: new MyHome()));
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Coffee Oven Roast"),
        backgroundColor: Colors.blue,
      ),
      body: new TabBarView(
        children: <Widget>[
          new RoastTab(),
          new RecipesTab(),
          new SettingsTab(),
          new InfoTab()
        ],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: new Icon(Icons.web_asset),
            ),
            new Tab(
              icon: new Icon(Icons.view_list),
            ),
            new Tab(
              icon: new Icon(Icons.settings),
            ),
            new Tab(
              icon: new Icon(Icons.info_outline),
            ),
          ],
          controller: controller,
        ),
      ),
    );
  }
}
