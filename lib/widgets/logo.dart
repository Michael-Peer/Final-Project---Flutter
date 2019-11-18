import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0), color: Colors.white),
      child: Icon(
        Icons.directions_car,
        color: Colors.black,
        size: 65.0,
      ),
    );
  }
}
