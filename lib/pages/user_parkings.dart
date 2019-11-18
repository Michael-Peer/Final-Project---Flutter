import 'package:flutter/material.dart';
import 'package:parking_location/pages/parking_info_page.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';

class UserParkingList extends StatefulWidget {
  final ConnectedParkingModel model;

  UserParkingList(this.model);

  @override
  _UserParkingListState createState() => _UserParkingListState();
}

class _UserParkingListState extends State<UserParkingList> {
  @override
  void initState() {
    widget.model.fetchParkings(onlyForUser: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConnectedParkingModel>(
      builder:
          (BuildContext context, Widget child, ConnectedParkingModel model) {
        return WillPopScope(
          onWillPop: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(model.parkings[index].address),
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.endToStart) {
                      model.deleteParking(index);
                    }
                  },
                  background: Container(color: Colors.red),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        subtitle: Text(model.user.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ParkingInfoPage(model, index),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(model.parkings[index].image),
                        ),
                        title: Text(model.parkings[index].location.address),
                      ),
                      Divider(
                        color: Colors.black,
                      ),

                    ],
                  ),
                );
              },
              itemCount: model.parkings.length,
            ),
          ),
        );
      },
    );
  }
}
