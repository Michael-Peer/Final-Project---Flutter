import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:parking_location/classes/parkingModel.dart';
import 'package:parking_location/pages/parking_info_page.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';

import 'all_parkings_list.dart';

class ExampleAnima extends StatefulWidget {
  final ConnectedParkingModel model;

  ExampleAnima(this.model);

  @override
  _ExampleAnimaState createState() => _ExampleAnimaState();
}

class _ExampleAnimaState extends State<ExampleAnima> {
  @override
  void initState() {
    widget.model.fetchParkings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConnectedParkingModel>(builder:
        (BuildContext context, Widget child, ConnectedParkingModel model) {
      return Scaffold(
          // backgroundColor: Color(0XFF2962FF),
          backgroundColor: Colors.deepPurple[900],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.deepPurple[900],
            title: Text('List'),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return _buildParkingCard(context, index, model);
              },
            ),
          ));
    });
  }

  Widget _buildParkingCard(
      BuildContext context, int index, ConnectedParkingModel model) {
    Parking item = model.parkings.elementAt(index);
    var exAnimatedContainer = AnimatedContainer(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 500),
        color: Colors.white,
        height: item.expanded
            ? MediaQuery.of(context).size.height * 0.30
            : MediaQuery.of(context).size.height * 0.13,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.network(
                model.parkings[index].image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
    var notExAnimatedContainer = AnimatedContainer(
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 500),
      color: Colors.white,
      height: item.expanded
          ? MediaQuery.of(context).size.height * 0.30
          : MediaQuery.of(context).size.height * 0.13,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.13,
            child: Image.network(
              model.parkings[index].image,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: () {
        print('pressed');
        setState(() {
          item.expanded = !item.expanded;
        });
      },
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: item.expanded ? exAnimatedContainer : notExAnimatedContainer),
    );
  }
}
