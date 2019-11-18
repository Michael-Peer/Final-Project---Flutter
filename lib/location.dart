import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './classes/location_class.dart';
import 'package:location/location.dart' as geoloc;

class LocationLogic extends StatefulWidget {
  final Function setLocation;

  LocationLogic(
    this.setLocation,
  );

  @override
  _LocationLogicState createState() => _LocationLogicState();
}

class _LocationLogicState extends State<LocationLogic> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Uri _staticMapUri;
  final TextEditingController _addressInputController = TextEditingController();

  LocationData _locationData;

//when user lose focus static map fired
  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

//prevent memory leak
  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }


//get the map
//if geocode is false we already have data
  getStaticMap(String address,
      {bool geocode = true,
      double lat,
      double lng,
      String city,
      String street,
      String streetNumber}) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      final Uri uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyCgdLPR87KcBEM2rekUjuPhob1TFIhORCQ'},
      );
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final city =
          decodedResponse['results'][0]['address_components'][2]['long_name'];
      final street =
          decodedResponse['results'][0]['address_components'][1]['long_name'];
      final streetNumber =
          decodedResponse['results'][0]['address_components'][0]['long_name'];
      final stringStreetNumber = streetNumber.toString();

      print('full address');
      print(decodedResponse['results'][0]['address_components']);
      print('street number');
      print(
          decodedResponse['results'][0]['address_components'][0]['long_name']);
      print('street ');
      print(
          decodedResponse['results'][0]['address_components'][1]['long_name']);
      print('city');
      print(
          decodedResponse['results'][0]['address_components'][2]['long_name']);

//coors of the location
      final cords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
          address: formattedAddress,
          latitude: cords['lat'],
          longitude: cords['lng'],
          city: city,
          street: street,
          streetNumber: stringStreetNumber);
    } else {
      _locationData = LocationData(
          address: address,
          latitude: lat,
          longitude: lng,
          city: city,
          street: street,
          streetNumber: streetNumber);
    }


    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyCgdLPR87KcBEM2rekUjuPhob1TFIhORCQ');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
      Marker('position', 'Position', _locationData.latitude,
          _locationData.longitude)
    ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);
    widget.setLocation(_locationData);

    print('32489024890243908230982340983240');
    print('32489024890243908230982340983240');

    print(_locationData);
    print('32489024890243908230982340983240');
    print('32489024890243908230982340983240');

    setState(() {
      _addressInputController.text = _locationData.address;
      _staticMapUri = staticMapUri;
    });
  }


//get automate adrress of the user
  Future _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()}, ${lng.toString()}',
        'key': 'AIzaSyCgdLPR87KcBEM2rekUjuPhob1TFIhORCQ'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];

    final city =
        decodedResponse['results'][0]['address_components'][2]['long_name'];
    final street =
        decodedResponse['results'][0]['address_components'][1]['long_name'];
    final streetNumber =
        decodedResponse['results'][0]['address_components'][0]['long_name'];

    print('full address');
    print(decodedResponse['results'][0]['address_components']);
    print('street number');
    print(decodedResponse['results'][0]['address_components'][0]['long_name']);
    print('street ');
    print(decodedResponse['results'][0]['address_components'][1]['long_name']);
    print('city');
    print(decodedResponse['results'][0]['address_components'][2]['long_name']);

    // print('fsfsfsfssffsfsfsfsfss');
    // print(decodedResponse['results'][0]['address_components']['street_number']
    //     ['long_name']);
    //         print('fsfsfsfssffsfsfsfsfss');

    final data = {
      'address': formattedAddress,
      'city': city,
      'street': street,
      'streetNumber': streetNumber
    };

    return data;
  }


//location of the user on button pressed
  void _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    final data =
        await _getAddress(currentLocation.latitude, currentLocation.longitude);
    final address = data['address'];
    final city = data['city'];
    final street = data['street'];
    final streetNumber = data['streetNumber'];
    getStaticMap(address,
        geocode: false,
        lat: currentLocation.latitude,
        lng: currentLocation.longitude,
        city: city,
        street: street,
        streetNumber: streetNumber);
  }


//when user lose focus
  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valid location found';
            }
          },
          // decoration: InputDecoration(labelText: 'Address'),
             decoration: InputDecoration(
        labelText: 'Address',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        fillColor: Colors.yellow,
        prefixIcon: Icon(Icons.location_on),
      ),
        ),
        SizedBox(height: 10.0),
        FlatButton(
          child: Text('Your location'),
          onPressed: _getUserLocation,
        ),
        _staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString())
      ],
    );
  }
}
