import 'package:flutter/material.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import '../parkings.dart';
import 'package:scoped_model/scoped_model.dart';
import '../location.dart';
import '../classes/location_class.dart';
import './auto_create.dart';
import '../image.dart';
import 'dart:io';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final Map<String, dynamic> _formData = {
    'address': null,
    'image': null,
    'location': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ScopedModelDescendant<ConnectedParkingModel>(
          builder: (BuildContext context, Widget child,
              ConnectedParkingModel model) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: <Widget>[
                  // _buildAddressTextField(),
                  // SizedBox(
                  //   height: 12.0,
                  // ),
                  // _buildImageTextField(),
                  SizedBox(
                    height: 12.0,
                  ),
                  LocationLogic(
                    _setLocation,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ImageInput(_setImage),
                  SizedBox(
                    height: 16.0,
                  ),

                  // model.isLoading
                  //     ? Center(child: CircularProgressIndicator())
                  //     :

                  // child: RaisedButton(
                  //         child: Text('create parking'),
                  //         onPressed: () => _submitForm(model.addParking, model),
                  //       ),
                  GestureDetector(
                    onTap: () => _submitForm(model.addParking, model),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Create Parking',
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                  // RaisedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => AutoCreate()),
                  //     );
                  //   },
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _setLocation(LocationData locData) {
    _formData['location'] = locData;
    print('32489024890243908230982340983240');
    print('32489024890243908230982340983240');

    print(_formData['location']);
    print('32489024890243908230982340983240');
    print('32489024890243908230982340983240');
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(Function addParking, ConnectedParkingModel model) {
//if not validate
    if (!_formKey.currentState.validate() || _formData['image'] == null) {
      return;
    }
    _formKey.currentState.save();
    addParking(
      _formData['address'],
      _formData['image'],
      _formData['location'],
    ).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Parkings(model)),
      );
    });
  }

  TextFormField _buildAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Address',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        fillColor: Colors.yellow,
        prefixIcon: Icon(Icons.location_on),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
      },
      onSaved: (value) {
        _formData['address'] = value;
      },
    );
  }

  TextFormField _buildImageTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Image',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        fillColor: Colors.yellow,
        prefixIcon: Icon(Icons.image),
      ),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Image is required';
      //   }
      // },
      // onSaved: (value) {
      //   _formData['image'] = value;
      // },
    );
  }
}
