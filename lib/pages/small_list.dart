import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:parking_location/classes/parkingModel.dart';
import 'package:parking_location/pages/parking_info_page.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:parking_location/ui/expandedContainer.dart';
import 'package:parking_location/ui/notExpandedContainer.dart';
import 'package:scoped_model/scoped_model.dart';

import 'all_parkings_list.dart';

class SmallList extends StatefulWidget {
  final ConnectedParkingModel model;

  SmallList(this.model);

  @override
  _SmallListState createState() => _SmallListState();
}

class _SmallListState extends State<SmallList> {
  TextEditingController _textEditingController;
  List<Parking> _dupList = [];
  List<Parking> parkings = [];
  List _height;

  @override
  void initState() {
    widget.model.fetchParkings();
    _textEditingController = TextEditingController();
    parkings = widget.model.parkings;
    _dupList = widget.model.parkings;
    _height = List.generate(
      widget.model.parkings.length,
      (i) => 60.0
    ).toList();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConnectedParkingModel>(builder:
        (BuildContext context, Widget child, ConnectedParkingModel model) {
      return Scaffold(
        // backgroundColor: Color(0XFF2962FF),
        backgroundColor: Colors.deepPurple[900],
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Colors.deepPurple[900],
        //   title: Text('All Parkings'),
        // ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _textEditingController,
                  onChanged: (String value) {
                    if (value != "") {
                      setState(() {
                        parkings = parkings
                            .where((test) => test.location.city
                                .toLowerCase()
                                .contains(value))
                            .toList();
                      });
                    } else {
                      setState(() {
                        parkings = _dupList;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "Search",
                    hintText: "Search by city",
                    labelStyle: TextStyle(color: Colors.white),
                    prefix: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: parkings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildParkingCard(context, index, model, parkings);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildParkingCard(BuildContext context, int index,
      ConnectedParkingModel model, List<Parking> _parkings) {
   
    // Parking item = model.parkings.elementAt(index);
    Parking item = _parkings.elementAt(index);

//default state
    final notExpandedContainer = AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.deepPurple[800],
        // borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      height: item.expanded
          ? MediaQuery.of(context).size.height * 0.30
          : MediaQuery.of(context).size.height * 0.13,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start  ,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.13,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
              child: Image.network(
                model.parkings[index].image,
                // _parkings[index].image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  // model.parkings[index].location.street +
                  //     ' ' +
                  //     model.parkings[index].location.streetNumber +
                  //     ', ' +
                  //     model.parkings[index].location.city,
                  _parkings[index].location.street +
                      ' ' +
                      _parkings[index].location.streetNumber +
                      ' ' +
                      _parkings[index].location.city,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          item.expanded = !item.expanded;
                        });
                      },
                    ))
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkingInfoPage(model, index),
                ),
              );
            },
          ),
          SizedBox(
            width: 14.0,
          )
        ],
      ),
    );

    final expandedContainer = AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.deepPurple[800],
        // borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      height: item.expanded
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.height * 0.13,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.network(
              // model.parkings[index].image,
              _parkings[index].image,
              // width: double.infinity,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            // model.parkings[index].location.street +
            //     ' ' +
            //     model.parkings[index].location.streetNumber +
            //     ', ' +
            //     model.parkings[index].location.city,
            _parkings[index].location.street +
                ' ' +
                _parkings[index].location.streetNumber +
                ' ' +
                _parkings[index].location.city,

            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  tooltip: 'Press to navigate with google maps',
                  icon: Icon(
                    Icons.location_on,
                    size: 45.0,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    model.launchMaps(index);
                  }),
              IconButton(
                  tooltip: 'Press to navigate with waze',
                  icon: Icon(
                    Icons.navigation,
                    size: 45.0,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    model.launchWaze(index);
                  }),
              IconButton(
                  tooltip: 'press to see full map',
                  icon: Icon(
                    Icons.map,
                    size: 45.0,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    model.launchStreetView(index);
                  })
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_up),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    item.expanded = !item.expanded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: item.expanded ? expandedContainer : notExpandedContainer,

    );
  }
}
