import 'package:flutter/material.dart';
import 'package:parking_location/pages/auto_create.dart';
import 'package:parking_location/pages/form.dart';
import 'package:parking_location/pages/user_parkings.dart';
import 'package:parking_location/pages/users_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';


class MainDrawer extends StatelessWidget {
  ConnectedParkingModel model;
  
  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => AutoCreate()),
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
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              model.signOut().then((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Leading table'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserList(model)),
              );
            },
          ),

        ],
      ),
    ); 
  }
}