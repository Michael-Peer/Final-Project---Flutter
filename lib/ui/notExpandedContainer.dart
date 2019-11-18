import 'package:flutter/material.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import '../classes/parkingModel.dart';

class NotExpandedContainer extends StatefulWidget {
    Parking item;
  ConnectedParkingModel model;
  int index;

  NotExpandedContainer(this.item, this.model,this.index);

  @override
  _NotExpandedContainerState createState() => _NotExpandedContainerState();
}

class _NotExpandedContainerState extends State<NotExpandedContainer> {
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
                  widget.model.parkings[widget.index].image,
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
                  widget.model.parkings[widget.index].location.street +
                      ' ' +
                      widget.model.parkings[widget.index].location.streetNumber +
                      ', ' +
                      widget.model.parkings[widget.index].location.city,
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
                          widget.item.expanded = !widget.item.expanded;
                        });
                      },
                    ))
              ],
            ),
          ),
          Icon(
            Icons.info,
            color: Colors.white,
          ),
          SizedBox(
            width: 14.0,
          )
        ],
      ),
    );
  }
}