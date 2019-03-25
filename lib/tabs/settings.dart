import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsTabState();
  }
}

class _SettingsTabState extends State<SettingsTab> {
  String temperature = 'celcius';
  String weight = 'gr';

  @override
  void initState() {
    super.initState();
    getUnits();
  }

  getUnits() async {
    SharedPreferences units = await SharedPreferences.getInstance();
    String temp = units.getString('tempUnit');
    if (temp != null) {
      setState(() {
        temperature = temp;
      });
    }
    String wght = units.getString('weightUnit');
    if (wght != null) {
      setState(() {
        weight = wght;
      });
    }
  }

  setTemp() async {
    SharedPreferences temps = await SharedPreferences.getInstance();
    if (temperature == 'celcius') {
      temps.setString('tempUnit', 'farenheit');
      setState(() {
        temperature = 'farenheit';
      });
    } else {
      temps.setString('tempUnit', 'celcius');
      setState(() {
        temperature = 'celcius';
      });
    }
  }

  setWeight() async {
    SharedPreferences weights = await SharedPreferences.getInstance();
    if (weight == 'gr') {
      weights.setString('weightUnit', 'oz');
      setState(() {
        weight = 'oz';
      });
    } else {
      weights.setString('weightUnit', 'gr');
      setState(() {
        weight = 'gr';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      print('set to something');
                      setTemp();
                    },
                    trailing: Text(
                      (temperature == 'celcius') ? '°F' : '°C',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0),
                    ),
                    title: const Text(
                      'Temperature',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setWeight();
                    },
                    trailing: Text(
                      (weight == 'gr') ? 'oz' : 'gr',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0),
                    ),
                    title: const Text(
                      'Weight',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
