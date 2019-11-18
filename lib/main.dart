import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_location/scoped-models/connected_parking.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
import './pages/login_page.dart';
import './parkings.dart';

void main() {
  MapView.setApiKey('API KEY HERE');
  runApp(MyApp());
}




//Checked
//TODO: Disable landscape mode --> checked
//TODO: Add street view --> checked
//TODO: Add if mounted to async setState --> checked?
//TODO: Launch waze -->checked
//TODO: Show user name at the parking he addes --> checked
//TODO: Show the time parking added --> checked
//TODO: Show distance in kilomete if above 1000 meter --> checked
//TODO: Add facebook sign in -->checked
//TODO: Show user parking list --> checked, delay problem. mayble dont let go back only from drawer
//TODO: All parkings list page -->checked, grey line problem
//TODO: Beautify the drawer -->checked?






//Left
//TODO: try catch to the function
//TODO: show timer 
//TODO: CHECK AT START IF HAS INTERNET AND LOCATION ON
//TODO: report parking screen -- checked
//TODO: Filter by city/street
//TODO: Error at logout -->related to the points
//TODO: seperate the connected to different classes
//TODO: Focus on first list item
//TODO: Add circular progress indicator
//TODO: 2 Versions of all parking list - one big with the container and the second tuny with cards -->checked
//TODO: in the tiny card list - animation card expaned when click
//TODO: Leading table - like plants cards --> checked
//TODO: users list - list operation help --> checked
//ux/ui stackoverflow about the colors
//show gridview/listview
//notification

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConnectedParkingModel _model = ConnectedParkingModel();

  bool _isAuth = false;

  @override
  //check if the user signed in
  void initState() {
    _model.autoAuth();

    _model.userSubject.listen((bool isAuth) {

      setState(() {
        _isAuth = isAuth;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //disable landscape mode
    SystemChrome.setPreferredOrientations(

      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ]
    );
    return ScopedModel<ConnectedParkingModel>(
      model: _model,
      child: MaterialApp(
        routes: {
          //if signed in navigate to home page
          '/': (BuildContext context) =>
              !_isAuth ? LoginPage() : Parkings(_model),
          '/home': (BuildContext context) => Parkings(_model),
          '/login': (BuildContext context) => LoginPage(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: LoginPage(),
      ),
    );
  }
}
