import 'package:flutter/material.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import '../classes/parkingModel.dart';

class ExpandedContainer extends StatefulWidget {
  Parking item;
  ConnectedParkingModel model;
  int index;

  ExpandedContainer(this.item, this.model,this.index);

  @override
  _ExpandedContainerState createState() => _ExpandedContainerState();
}

class _ExpandedContainerState extends State<ExpandedContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.deepPurple[800],
        // borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      height: widget.item.expanded
          ? MediaQuery.of(context).size.height * 0.30
          : MediaQuery.of(context).size.height * 0.13,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.network(
                widget.model.parkings[widget.index].image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
               icon:Icon(Icons.keyboard_arrow_up) ,
               iconSize: 30.0,
               color: Colors.white,
               onPressed: () {
                  setState(() {
                          widget.item.expanded = !widget.item.expanded;
                        });
               },
              ),
            ),
          )
        ],
      ),
    );
  }
}