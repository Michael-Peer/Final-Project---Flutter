import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.network("http://i63.tinypic.com/16p2xu.jpg",
              color: Colors.lightBlueAccent,
              colorBlendMode: BlendMode.colorBurn,
              fit: BoxFit.cover),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.account_balance),
                            SizedBox(height: 10),
                            Text("My Stats"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/manager');
                          },
                          child: Container(
                            color: Colors.lightBlueAccent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Icon(Icons.accessibility, color: Colors.white),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    "Add Parking",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.lime,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.access_alarm),
                        SizedBox(height: 20),
                        Text("Workout"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
