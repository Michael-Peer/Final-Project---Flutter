import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:loader_search_bar/loader_search_bar.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:search_widget/widget/no_item_found.dart';
import '../classes/parkingModel.dart';
import 'package:flutter/widgets.dart';

import 'parking_info_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:search_widget/search_widget.dart';



class AllParkings extends StatefulWidget {
  final ConnectedParkingModel model;


  AllParkings(this.model);
  @override
  _AllParkingsState createState() => _AllParkingsState();
}

class _AllParkingsState extends State<AllParkings> {

  // @override
  // void initState() {
  //   widget.model.fetchParkings();
  //   super.initState();
  // }
TextEditingController _textEditingController;
 List<Parking> _dupList = [];
List<Parking> parkings = [];





  @override
  void initState() {
    widget.model.fetchParkings();
    _textEditingController = TextEditingController();
    parkings = widget.model.parkings;
    _dupList = widget.model.parkings;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
// List<Parking> parkings = widget.model.parkings;


    return ScopedModelDescendant<ConnectedParkingModel>(builder:
        (BuildContext context, Widget child, ConnectedParkingModel model) {
        
      return Scaffold(
//  appBar: AppBar(
//    leading: Icon(Icons.search),
//    title: TextField(
//      controller: _textEditingController,
//      onChanged: (String value) {
//        if(value != "") {
//          setState(() {
//           parkings = parkings.where((test) => test.location.city.toLowerCase().contains(value)).toList();
//          });
        
//        } else {
//          setState(() {
//           parkings = _dupList; 
//          });
//        }
//      },
//    ),
//  ),
          backgroundColor: Colors.white,
        
          body: 
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0), 
                  //Search
                  child: TextField(
                         controller: _textEditingController,
     onChanged: (String value) {
       if(value != "") {
         setState(() {
          parkings = parkings.where((test) => test.location.city.toLowerCase().contains(value)).toList();
         });
        
       } else {
         setState(() {
          parkings = _dupList; 
         });
       }
     },
decoration: InputDecoration(
  labelText: "Search",
  hintText: "Search by city",
  prefix: Icon(Icons.search),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25.0))
  )
),
                  ),
                  
                ),
                Expanded(
                                  child: ListView.builder(
                    // itemCount: model.parkings.length,
                    // itemCount: widget._parkings.length,
                    itemCount: parkings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildParkingCard(context, index, model, parkings);
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

Widget _buildParkingCard(
    BuildContext context, int index, ConnectedParkingModel model,  List<Parking> _parkings) {
  final String mapsUrl = "https://image.flaticon.com/icons/svg/281/281767.svg";
  final String wazeUrl = "https://image.flaticon.com/icons/svg/732/732257.svg";
  final String streetsUrl = "https://image.flaticon.com/icons/svg/500/500745.svg";
  final String infoUrl = "https://image.flaticon.com/icons/svg/1695/1695305.svg";
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 12.0, spreadRadius: 2.0)
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  color: Colors.blue[50]),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: Colors.blue[50],
                child: ClipPath(
                  clipper: WaveClipperOne(reverse: true),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    color: Color(0XFF0D47A1),
                  ),
                ),
              )
            ],
          ),
          Image.network(
            // model.parkings[index].image,
            _parkings[index].image,
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.27,
            left: 6.0,
            right: 6.0,
            child: Text(
              // model.parkings[index].location.street +
              //     ' ' +
              //     model.parkings[index].location.streetNumber +
              //     ', ' +
              //     model.parkings[index].location.city,
              _parkings[index].location.street + '' + _parkings[index].location.streetNumber + ', ' + _parkings[index].location.city,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38 + 10,
            left: 6.0,
            right: 6.0,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                            GestureDetector(
                    child: SvgPicture.network(
                      infoUrl,
                      height: 50.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkingInfoPage(model, index),
                ),
              );
                    },
                  ),
                                          GestureDetector(
                    child: SvgPicture.network(
                      mapsUrl,
                      height: 50.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                      model.launchMaps(index);
                    },
                  ),
                                          GestureDetector(
                    child: SvgPicture.network(
                      wazeUrl,
                      height: 50.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                      model.launchWaze(index);
                    },
                  ),
                                          GestureDetector(
                    child: SvgPicture.network(
                      streetsUrl,
                      height: 50.0,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator(),
                    ),
                    onTap: () {
                      model.launchStreetView(index);
                    },
                  ),
                // IconButton(
                //   icon: Icon(
                //     Icons.info,
                //     color: Colors.blue[50],
                //   ),
                //   iconSize: 50,
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(
                //     Icons.map,
                //     color: Colors.blue[50],
                //   ),
                //   iconSize: 50,
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(
                //     Icons.navigation,
                //     color: Colors.blue[50],
                //   ),
                //   iconSize: 50,
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(
                //     Icons.location_on,
                //     color: Colors.blue[50],
                //   ),
                //   iconSize: 50,
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ExampleAnima(model)),
                //     );
                //   },
                // )
                
              ],
            ),
          ),
      
        ],
      ),
    ),
  );
}

class PopupListItemWidget extends StatelessWidget {
  final Parking item;

  PopupListItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        item.city,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class SelectedItemWidget extends StatelessWidget {
  final Parking selectedItem;
  final VoidCallback deleteSelectedItem;

  SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 4.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.city,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
  
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  MyTextField(this.controller, this.focusNode);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: new TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x4437474F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme
                .of(context)
                .primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}
