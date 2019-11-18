import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_location/pages/all_parkings_list.dart';
import 'package:map_view/map_view.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../classes/location_class.dart';
import 'dart:async';
import 'package:quiver/async.dart';
import '../widgets/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParkingInfoPage extends StatefulWidget {
  final ConnectedParkingModel model;
  final int index;

  ParkingInfoPage(this.model, this.index);

  @override
  _ParkingInfoPageState createState() => _ParkingInfoPageState();
}

class _ParkingInfoPageState extends State<ParkingInfoPage> {
  String _distance = "";
  bool km = false;
  int _start = 10;
  int _current = 10;
  final String mapsUrl = "https://image.flaticon.com/icons/svg/281/281767.svg";
  final String wazeUrl = "https://image.flaticon.com/icons/svg/732/732257.svg";
  final String streetsUrl =
      "https://image.flaticon.com/icons/svg/500/500745.svg";

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  void initState() {
    super.initState();

    widget.model.calculateDistance(widget.index).then((value) {
      // startTimer();
      //prevent memory leak
      if (mounted) {
        //from meter to kilometer
        if (value > 1000) {
          value = value / 1000;
          setState(() {
            km = true;
            _distance = value.toInt().toString();
          });
        } else {
          setState(() {
            _distance = value.toInt().toString();
          });
        }
      }
    });
  }

  void _showFullGoogleMap() async {
    double lat = widget.model.parkings[widget.index].location.latitude;
    double lng = widget.model.parkings[widget.index].location.longitude;
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'There is a problem';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      // backgroundColor: Color(0XFF0D47A1),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            // color: Color(0XFFBBDEFB),

            // color: Color(0XFF0D47A1),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 130,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 20.0,
                          spreadRadius: 10.0)
                    ],
                    color: Color(0XFF0D47A1),
                    //color: Color(0XFF0D47A1),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child:
                      //stack part(photo+gardient)
                      Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              widget.model.parkings[widget.index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 190.0),
                            height: 110.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[ 
                                  Color(0X000D47A1),
                                  Color(0XFF0D47A1)
                                  // Color(0X00E3F2FD),
                                  // Color(0XFFE3F2FD)
                                  // Color(0X00BBDEFB),
                                  // Color(0XFFBBDEFB)
                                ],
                                stops: [0.0, 0.9],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                        //address
                      ),
                      Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          widget.model.parkings[widget.index].location.address,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      //Icon row
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              //icon buttons for the padding&tooltip
                              IconButton(
                                tooltip: 'Distance from destination',
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.directions_car,
                                  size: 55.0,
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  km
                                      ? _distance + ' ' + 'Km'
                                      : _distance + ' ' + 'M',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                tooltip: 'The time the parking was added',
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.access_time,
                                  size: 55.0,
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  widget.model.parkings[widget.index].time,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                tooltip: 'The user who reported',
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.person,
                                  size: 55.0,
                                ),
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  widget.model.parkings[widget.index].userName,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ScopedModelDescendant<ConnectedParkingModel>(
            builder: (BuildContext context, Widget child,
                ConnectedParkingModel model) {
              return //3  icons in a row
                  ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // IconButton(
                  //     tooltip: 'Press to navigate with google maps',
                  //     icon: Icon(
                  //       Icons.location_on,
                  //       size: 60.0,
                  //       color: Colors.blue,
                  //     ),
                  //     onPressed: () {
                  //       model.launchMaps(widget.index);
                  //     }),
                  Tooltip(
                    message: "Navigate With Google Maps",
                    child:                GestureDetector(
                    child: SvgPicture.network(
                      mapsUrl,
                      height: 60.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                      model.launchMaps(widget.index);
                    },
                  ),
                  ),
   
                  // IconButton(
                  //     tooltip: 'Press to navigate with waze',
                  //     icon: Icon(
                  //       Icons.navigation,
                  //       size: 60.0,
                  //       color: Colors.red,
                  //     ),
                  //     onPressed: () {
                  //       model.launchWaze(widget.index);
                  //     }),

                  Tooltip(
                    message: "Navigate with Waze",
                    child:            GestureDetector(
                    child: SvgPicture.network(
                      wazeUrl,
                      height: 60.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                      model.launchWaze(widget.index);
                    },
                  ),
                  ),
       
                  // IconButton(
                  //     tooltip: 'press to see full map',
                  //     icon: Icon(
                  //       Icons.map,
                  //       size: 60.0,
                  //       color: Colors.blueAccent,
                  //     ),
                  //     onPressed: () {
                  //       model.launchStreetView(widget.index);
                  //     })

                  Tooltip(
                    message: "View in Google Street View",
                    child: GestureDetector(
                      child: SvgPicture.network(
                        streetsUrl,
                        height: 60.0,
                        placeholderBuilder: (context) =>
                            CircularProgressIndicator(),
                      ),
                      onTap: () {
                        model.launchStreetView(widget.index);
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             expandedHeight: 250.0,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Hero(
//                   tag: model.parkings[index].id,
//                   child: Image.network(
//                     model.parkings[index].image,
//                     height: 300.0,
//                     fit: BoxFit.cover,
//                   )),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               Text(
//                 model.parkings[index].location.address,
//                 style: TextStyle(fontSize: 18.0),
//               ),
//             ]),
//           )
//         ],
//       ),

// CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             //TODO: gradient
//             expandedHeight: 250.0,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Hero(
//                   tag: model.parkings[index].id,
//                   child: Image.network(
//                     model.parkings[index].image,
//                     height: 300.0,
//                     fit: BoxFit.cover,
//                   )),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       model.parkings[index].location.address,
//                       style: TextStyle(
//                           fontSize: 24.0,
//                           fontFamily: 'Oswald',
//                           color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(30.0),
//                   child: Container(
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black,
//                           blurRadius: 10.0,
//                           offset: Offset(3.0, 10.0),
//                           // spreadRadius: 2.0,
//                         )
//                       ],
//                     ),
//                     child: Icon(Icons.location_on,
//                         color: Color(0XFF0D47A1), size: 60.0),
//                   ),
//                 ),
//                 Text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa")

//               ],
//             ),
//           )
//         ],
//       ),

// Container(
//         constraints: BoxConstraints.expand(),
//         color: Color(0XFF0D47A1),
//         child: Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   constraints: BoxConstraints.expand(height: 300),
//                   child: Image.network(
//                     model.parkings[index].image,
//                     fit: BoxFit.cover,
//                     height: 300.0,
//                   ),
//                 ),
//                 Container(
//                   margin: new EdgeInsets.only(top: 190.0),
//                   height: 110.0,
//                   decoration: new BoxDecoration(
//                     gradient: new LinearGradient(
//                       colors: <Color>[
//                         new Color(0X000D47A1),
//                         new Color(0XFF0D47A1)
//                       ],
//                       stops: [0.0, 0.9],
//                       begin: const FractionalOffset(0.0, 0.0),
//                       end: const FractionalOffset(0.0, 1.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 18.0),
//               child: Text(
//                 model.parkings[index].location.address,
//                 style: TextStyle(
//                     fontSize: 24.0, fontFamily: 'Oswald', color: Colors.black),
//               ),
//             ),
//             SizedBox(
//               height: 15.0,
//             ),
//             Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black,
//                     blurRadius: 10.0,
//                     offset: Offset(3.0, 10.0),
//                     // spreadRadius: 2.0,
//                   )
//                 ],
//               ),
//               child: Center(
//                 child: Icon(Icons.location_on,
//                     color: Color(0XFF0D47A1), size: 60.0),
//               ),
//             ),
//             // Text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa")
//           ],
//         ),
//       ),

//!!!
//last change
//!!!

// return Scaffold(
//       // backgroundColor: Color(0XFF0D47A1),
//       // appBar: AppBar(),

//       // appBar: AppBar(
//       //   title: Text(model.parkings[index].address),
//       // ),
//       body: Container(
//         constraints: BoxConstraints.expand(),
//         color: Color(0XFF0D47A1),
//         child: Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   constraints: BoxConstraints.expand(height: 300),
//                   child: Image.network(
//                     model.parkings[index].image,
//                     fit: BoxFit.cover,
//                     height: 300.0,
//                   ),
//                 ),
//                 Container(
//                   margin: new EdgeInsets.only(top: 190.0),
//                   height: 110.0,
//                   decoration: new BoxDecoration(
//                     gradient: new LinearGradient(
//                       colors: <Color>[
//                         new Color(0X000D47A1),
//                         new Color(0XFF0D47A1)
//                       ],
//                       stops: [0.0, 0.9],
//                       begin: const FractionalOffset(0.0, 0.0),
//                       end: const FractionalOffset(0.0, 1.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 18.0, top: 12.0),
//                     child: Text(
//                       model.parkings[index].location.address,
//                       style: TextStyle(
//                           fontSize: 24.0,
//                           fontFamily: 'Oswald',
//                           color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       // Container(
//                       //   alignment: Alignment.center,
//                       //   height: 100,
//                       //   decoration: BoxDecoration(
//                       //     color: Colors.blue[50],
//                       //     shape: BoxShape.circle,
//                       //     boxShadow: [
//                       //       BoxShadow(
//                       //         color: Colors.black,
//                       //         blurRadius: 10.0,
//                       //         offset: Offset(3.0, 10.0),
//                       //         // spreadRadius: 2.0,
//                       //       )
//                       //     ],
//                       //   ),
//                       //   child: Center(
//                       //     child: Icon(Icons.location_on,
//                       //         color: Color(0XFF0D47A1), size: 60.0),
//                       //   ),
//                       // )
//                       Tooltip(
//                         message: 'Press to navigate',
//                         child: IconButton(
//                             icon: Icon(
//                               Icons.location_on,
//                               size: 60.0,
//                               color: Colors.black87,
//                             ),
//                             onPressed: _launchMaps),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.map,
//                           size: 60.0,
//                           color: Colors.black87,
//                         ),
//                         tooltip: 'Press to see the map',
//                         onPressed: _showMap,
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.work,
//                           size: 60.0,
//                           color: Colors.black87,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 40.0,
//                   ),
//                   // Text(
//                   //     "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessaThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessa"),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
