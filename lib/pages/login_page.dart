import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import '../widgets/logo.dart';

import '../parkings.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/./auto_create.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopScreen(),
    );
  }
}

class TopScreen extends StatelessWidget {
 final Color textColor = Colors.white;
 final facebookIcon = "https://image.flaticon.com/icons/svg/1384/1384053.svg";
 final gmailIcon = "https://image.flaticon.com/icons/svg/281/281769.svg";
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConnectedParkingModel>(
      builder:
          (BuildContext context, Widget child, ConnectedParkingModel model) {
        return Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Color(0XFF0D47A1),
              ),
            ),
            Positioned(
              top: 140,
              left: MediaQuery.of(context).size.width / 3,
              child: Text('ParkE',
                  style: TextStyle(
                      fontSize: 55.0,
                      fontFamily: 'Oswald',
                      color: textColor)),
            ),
            Center(
              child: Logo(),
            ),
            //sign in button

            Positioned(
              right: 20,
              left: 20,
              bottom: 50,
              child: GestureDetector(
                onTap: () => model.facebookSignIn().then(
                      (FirebaseUser user) {
                        print(user);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Parkings(model),
                          ),
                        );
                      },
                    ),
                child: Container(
                  alignment: Alignment.center,
                  height: 70.0,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(59, 89, 152, 1.0),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: SvgPicture.network(
                        facebookIcon,
                        height: 35.0,
                        placeholderBuilder: (context) =>
                            CircularProgressIndicator(),
                      ),
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Text(
                        'Facebook sign in',
                        style: TextStyle(fontSize: 24.0, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              left: 20,
              bottom: 135,
              child: GestureDetector(
                onTap: () => model.signInWithGoogle().then(
                      (FirebaseUser user) {
                        print(user);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Parkings(model),
                          ),
                        );
                      },
                    ),
                child: Container(
                  alignment: Alignment.center,
                  height: 70.0,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        // child: Icon(
                        //   Icons.mail,
                        //   size: 35.0,
                        // ),
                        child: SvgPicture.network(
                        gmailIcon,
                        height: 35.0,
                        placeholderBuilder: (context) =>
                            CircularProgressIndicator(),
                      ),
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Text(
                        'Google Sign In',
                        style: TextStyle(fontSize: 24.0, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
