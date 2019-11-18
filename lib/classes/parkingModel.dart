import 'package:flutter/material.dart';

import 'location_class.dart';
import 'dart:async';

//TODO: Implement userId

class Parking {
  final String id;
  final String address;
  final String image;
  final String imagePath;
  final bool isFavourite;
  final String userEmail;
  final String userId;
  final LocationData location;
  final String city;
  final String street;
  final String streetNumber;
  final String time;
  final String userName;
  bool expanded;

  Parking(
      {this.id,
      this.address,
      this.image,
      this.imagePath,
      this.isFavourite,
      this.userEmail,
      @required this.userId,
      this.location,
      this.city,
      this.street,
      this.streetNumber,
      this.time,
      @required this.userName,
      this.expanded = false});
}
