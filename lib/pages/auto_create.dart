import 'package:flutter/material.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import '../classes/location_class.dart';
import '../parkings.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AutoCreate extends StatefulWidget {
  @override
  _AutoCreateState createState() => _AutoCreateState();
}

class _AutoCreateState extends State<AutoCreate> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConnectedParkingModel>(builder:
        (BuildContext context, Widget child, ConnectedParkingModel model) {
      return Scaffold(
        body: Center(
          child: RaisedButton(
              onPressed: () =>
                  _submitInfo(model.addParking, model.getUserLocation, model)),
        ),
      );
    });
  }

//automate submit
  void _submitInfo(Function addParking, Function getUserLocation,
      ConnectedParkingModel model) async {
    final LocationData _locationData = await getUserLocation();
    final address = _locationData.address;
    print(_locationData.city);
        print(_locationData.street);
    print(_locationData.streetNumber);

    print(_locationData);
    _imageFile = await _openCamera();
    print(_imageFile);
    addParking(address, _imageFile, _locationData).then((_) {
      print('sfsffsfsfsfsfsfsfs');
      print(_imageFile);
      print('fsfsfsfsfsfsfsfs');
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Parkings(model)),
      );
    });
  }

//image from camera
  _openCamera() {
    return ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400.0);
    //     .then((File image) {
    //   setState(() {
    //     _imageFile = image;
    //   });
    // });
  }
}
