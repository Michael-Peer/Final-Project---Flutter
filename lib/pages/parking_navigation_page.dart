import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ParkingNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //clipper background
                    ClipPath(
                      clipper: WaveClipperOne(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: Color(0XFF0D47A1),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome Back,  " ,
                        style: TextStyle(
                            fontFamily: "Roberto",
                            fontSize: 36.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "Reports: " ,
                        style: TextStyle(
                            fontFamily: "Roberto",
                            fontSize: 28.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Points: " ,
                        style: TextStyle(
                            fontFamily: "Roberto",
                            fontSize: 28.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.white),
                      ),
                      SizedBox(height: 40.0),
                      
           
                    ],
                  ),
                ),
                Positioned(
                  top: 300,
                  child:            Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.access_alarm,)
                            // onTap: () {
                            //   model.launchStreetView(widget.index);
                            // },
                          ),
                          SizedBox(height: 8.0),
                
                              Text(
                                "Click to report",
                                style: TextStyle(
                                    fontFamily: "Roberto",
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white),
                              ),
                         
                        ],
                      ),
                )
                
              ],
      )
    );
  }
}
