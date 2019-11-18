import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_location/classes/user_model.dart';
import 'package:parking_location/pages/all_parkings_list.dart';
import 'package:parking_location/pages/auto_create.dart';
import 'package:parking_location/pages/list_manage.dart';
import 'package:parking_location/pages/user_parkings.dart';
import 'package:parking_location/pages/users_list.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import './pages/parking_info_page.dart';
import './pages/parking_navigation_page.dart';
import './pages/form.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flip_card/flip_card.dart';
import './pages/all_parkings_list.dart';
import 'classes/location_class.dart';

class Parkings extends StatefulWidget {
  final ConnectedParkingModel model;

  Parkings(
    this.model,
  );
  @override
  _ParkingsState createState() => _ParkingsState();
}

class _ParkingsState extends State<Parkings> {
  final Color textColor = Colors.white;

  //which page are we
// int _selectedPage = 0;
// final _pageOptions = [
// Parkings(),
// FirstPage(),
// FormPage()
// ];

  @override
  void initState() {
    widget.model.fetchParkings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    //image from camera
  _openCamera() {
    return ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400.0);
    //     .then((File image) {
    //   setState(() {
    //     _imageFile = image;
    //   });
    // });
  }

    //automate submit
  void _submitInfo() async {
    final LocationData _locationData = await widget.model.getUserLocation();
    final address = _locationData.address;
    print(_locationData.city);
        print(_locationData.street);
    print(_locationData.streetNumber);

    print(_locationData);
    final _imageFile = await _openCamera();
    print(_imageFile);
     widget.model.addParking(address, _imageFile, _locationData).then((_) {
      print('sfsffsfsfsfsfsfsfs');
      print(_imageFile);
      print('fsfsfsfsfsfsfsfs');
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Parkings( widget.model)),
      );
    });
  }

    void _pickImageMethod() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 150.0,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text("Choose Report Method"),
                  SizedBox(height: 8.0,),
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text("Report"),
                    onPressed: () {
                          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPage()),
              );
                    },
                  ),
                    FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text("Qucik Report"),
                                  onPressed: () {
                         _submitInfo();
                    },
                  ),
                  ],
              ),
            );
          });
    }




    return ScopedModelDescendant<ConnectedParkingModel>(
      builder:
          (BuildContext context, Widget child, ConnectedParkingModel model) {
        final String reportUrl =
            "https://image.flaticon.com/icons/svg/1159/1159435.svg";
        return Scaffold(
            drawer: _buildDrawer(model),
            appBar: AppBar(
                elevation: 1.0 * 100, backgroundColor: Color(0XFF0D47A1)),
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const <BottomNavigationBarItem>[

            //   BottomNavigationBarItem(

            //     icon: Icon(Icons.home),

            //     title: Text('Home'),
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.business),
            //     title: Text('Business'),
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.school),
            //     title: Text('School'),
            //   ),
            // ],
            //         ),
            // bottomNavigationBar: BottomNavigationBar(
            //   elevation: 0.0,
            //   currentIndex: _selectedPage,
            //   onTap: (int index) {
            //     setState(() {
            //      _selectedPage = index;
            //     });
            //   },
            //   items: [
            //     BottomNavigationBarItem(icon: Icon(Icons.home),
            //     title: Text('Home')
            //     ),
            //       BottomNavigationBarItem(icon: Icon(Icons.home),
            //     title: Text('Home')
            //     ),
            //       BottomNavigationBarItem(icon: Icon(Icons.home),
            //     title: Text('Home')
            //     ),
            //   ]
            // ),
            // body: _pageOptions[_selectedPage] == Parkings(model)  ? Stack(
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
                  top: 20.0,
                  left: 18.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome, " + model.user.name,
                        style: TextStyle(
                            fontFamily: "Roberto",
                            fontSize: 36.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "Reports: " + model.user.reports.toString(),
                        style: TextStyle(
                            fontFamily: "Roberto",
                            fontSize: 28.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "Points: " + model.user.points.toString(),
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
                  top: MediaQuery.of(context).size.height / 4 + 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        child: SvgPicture.network(
                          reportUrl,
                          height: 80.0,
                          placeholderBuilder: (context) =>
                              CircularProgressIndicator(),
                        ),
                        onTap: () {
                          _pickImageMethod();
                        },
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
                ),
                //profile container
                // Positioned(
                //   top: 80,
                //   right: 30,
                //   left: 30,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.26,
                //     // height: 200,
                //     // width: 400.0,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20.0),
                //       // color: Color(0XFF2196F3),
                //       color: Colors.blue[50],
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black,
                //           blurRadius: 10.0,
                //           offset: Offset(3.0, 10.0),
                //           // spreadRadius: 2.0,
                //         )
                //       ],
                //     ),
                //     //context of profile container
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.only(top: 45),
                //           child: Text(
                //             model.user.name,
                //             style: TextStyle(fontSize: 26.0),
                //           ),
                //         ),
                //         SizedBox(
                //           height: 10.0,
                //         ),
                //         // Text(
                //         //   'First of his name, king of the andals',
                //         //   style: TextStyle(fontSize: 16.0),
                //         // ),
                //         Padding(
                //           padding: const EdgeInsets.only(top: 25.0),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: <Widget>[
                //               Text(
                //                 'Reports',
                //                 style: TextStyle(fontSize: 20.0),
                //               ),
                //               // Text(
                //               //   'Likes',
                //               //   style: TextStyle(fontSize: 20.0),
                //               // ),
                //                      Text(
                //                 'Points',
                //                 style: TextStyle(fontSize: 20.0),
                //               ),
                //             ],
                //           ),
                //         ),
                //         SizedBox(
                //           height: 10.0,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: <Widget>[
                //             Text(
                //               model.user.reports.toString(),
                //               style: TextStyle(fontSize: 20.0),
                //             ),
                //             // Text(
                //             //    model.user.likes.toString(),
                //             //   style: TextStyle(fontSize: 20.0),
                //             // ),
                //                          Text(
                //               model.user.points.toString(),
                //               style: TextStyle(fontSize: 20.0),
                //             ),
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                //circle image
                // Positioned(
                //   top: 20,
                //   child: Container(
                //     height: 100.0,
                //     width: 100.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       // boxShadow: [BoxShadow(
                //       //     color: Color(0XFF0D47A1),
                //       //     //blur effect
                //       // blurRadius: 10.0,
                //       // offset: Offset(3.0, 3.0),
                //       // )],
                //       image: DecorationImage(
                //         fit: BoxFit.fill,
                //         image: NetworkImage(
                //             model.user.photoUrl),
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   left: 18.0,
                //   bottom: 260,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Text(
                //         'Recent',
                //         style: TextStyle(fontSize: 22.0),
                //       ),
                //       Text('View all',
                //           style: TextStyle(fontSize: 22.0))
                //     ],
                //   ),

                // ),

                //Recent + View all
                Positioned(
                  bottom: 260,
                  right: 18.0,
                  left: 18.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Recent',
                        style: TextStyle(fontSize: 22.0),
                      ),
                      GestureDetector(
                        child: Text(
                          'View all',
                          style: TextStyle(
                              fontSize: 22.0, color: Colors.lightBlue),
                        ),
                        //to see the whole parking list
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListManager(model)),
                          );
                        },
                      )
                    ],
                  ),
                ),

//line under the recent
                Positioned(
                  left: 18.0,
                  bottom: 244.0,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 2.5,
                    width: 28.0,
                    color: Color(0XFF0D47A1),
                  ),
                ),
//build the list
                Positioned(
                  bottom: 16,
                  child: Container(
                    height: 220.0,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      //list go from end to start
                      reverse: true,
                      //build the cards
                      itemBuilder: (BuildContext context, int index) {
                        return _buildParkingCard(context, index, model);
                      },
                      //length of the list,
                      itemCount: model.parkings.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            )
            // ) : _pageOptions[_selectedPage]
            );
      },
    );
  }

//build cards of the horizontal main list
  Widget _buildParkingCard(
      BuildContext context, int index, ConnectedParkingModel model) {
    EdgeInsets padding = index == 0
        ? const EdgeInsets.only(left: 20.0, right: 10.0, top: 4.0, bottom: 30.0)
        : const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ParkingInfoPage(model, index)),
          );
        },
        child: Container(
          width: 280.0,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: NetworkImage(
                  model.parkings[index].image,
                ),
                fit: BoxFit.cover),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                height: 30.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  model.parkings[index].location.street,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildParkingCard(
  //     BuildContext context, int index, ConnectedParkingModel model) {
  //   EdgeInsets padding = index == 0
  //       ? const EdgeInsets.only(left: 20.0, right: 10.0, top: 4.0, bottom: 30.0)
  //       : const EdgeInsets.only(
  //           left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);
  //   return Padding(
  //     padding: padding,
  //     child: GestureDetector(
  //       onTap: () {},
  //       child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10.0),
  //             color: Colors.blue,
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.black.withAlpha(70),
  //                   offset: Offset(3.0, 10.0),
  //                   blurRadius: 15.0)
  //             ],
  //             image: DecorationImage(
  //                 image: NetworkImage(model.parkings[index].image),
  //                 fit: BoxFit.fitHeight)),
  //         width: 140,
  // child: Stack(
  //   children: <Widget>[
  //     Align(
  //       alignment: Alignment.bottomCenter,
  //       child: Container(
  //         decoration: BoxDecoration(
  //             color: Color(0xFF273A48),
  //             borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(10.0),
  //                 bottomRight: Radius.circular(10.0))),
  //         height: 30.0,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               model.parkings[index].location.address,
  //               style: TextStyle(color: Colors.white),
  //             )
  //           ],
  //         ),
  //       ),
  //     )
  //   ],
  //         // ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDrawer(ConnectedParkingModel model) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(model.user.userEmail),
            accountName: Text(model.user.name),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(model.user.photoUrl),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2017/04/23/08/41/tel-aviv-2253289__340.jpg',
                    ),
                    fit: BoxFit.fill)),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Create Parking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPage()),
              );
            },
          ),
               ListTile(
            leading: Icon(Icons.format_list_numbered),
            title: Text('My Parkings'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UserParkingList(model)),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserParkingList(model)),
              );
            },
          ),
          //       ListTile(
          //   leading: Icon(Icons.supervised_user_circle),
          //   title: Text('Leading table'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => UserList(model)),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              model.signOut().then((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
        ],
      ),
    );
  }
}

// Widget _buildParkingCard(
//       BuildContext context, int index, ConnectedParkingModel model) {
//     return Card(
//       child: Column(
//         children: <Widget>[
//           Hero(
//               tag: model.parkings[index].id,
//               child: Image.network(model.parkings[index].image)),
//           Text(model.parkings[index].location.address),
//           ButtonBar(
//             alignment: MainAxisAlignment.center,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.location_on, color: Colors.blue, size: 40.0),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ParkingNavigation()),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.blue, size: 40.0),
//                 onPressed: () => model.deleteParking(index),
//               ),
//               IconButton(
//                 icon: Icon(Icons.info, color: Colors.blue, size: 40.0),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ParkingInfoPage(
//                           model.parkings[index].address,
//                           model.parkings[index].image,
//                           model.parkings[index].id,
//                           model,
//                           index),
//                     ),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.contact_mail, color: Colors.blue, size: 40.0),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                   );//                     MaterialPageRoute(builder: (context) => FormPage()),

//                 },
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
