import 'package:flutter/material.dart';

class User {
  String userEmail;
  String id;
  String token;
  String access;
  String name;
  String photoUrl;
  String userFireId;
  int reports;
  int points;
  int likes;

  User(
      {@required this.userEmail,
      @required this.id,
      @required this.token,
      @required this.access,
      @required this.name,
      @required this.photoUrl,
      this.userFireId,
      this.reports,
      this.points,
      this.likes});

  void raisePoints() {
    points = points + 2;
  }

  void decreasePoints() {
    points = points - 2;
  }

  int getPoints() {
    return points;
  }

  void raiseReports() {
    reports = reports + 1;
  }

  void decreaseReports() {
    reports = reports - 1;
  }
}
