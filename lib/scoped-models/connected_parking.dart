import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../classes/parkingModel.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:mime/mime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../classes/user_model.dart';
import '../classes/location_class.dart';
import 'package:location/location.dart' as geoloc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:android_intent/android_intent.dart';

class ConnectedParkingModel extends Model {
  List<Parking> _parkings = [];
  List<User> _users = [];
  PublishSubject<bool> _userSubject = PublishSubject();

  List<Parking> get parkings {
    return List.from(_parkings);
  }

  List<User> get users {
    return List.from(_users);
  }

//if user is auth or not
  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User _authUser;
  LocationData _locationData;
  FirebaseUser fireUser;
  bool _isLoading = false;
  final facebookLogin = FacebookLogin();
  String _speUserFireId;

  bool get isLoading {
    return _isLoading;
  }

  String get userFireId {
    return _speUserFireId;
  }

  
  User get user {
    return _authUser;
  }

  

//get the current address of the user
  Future getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()}, ${lng.toString()}',
        'key': 'API KEY HERE'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final address = decodedResponse['results'][0]['formatted_address'];
    final city =
        decodedResponse['results'][0]['address_components'][2]['long_name'];
    final street =
        decodedResponse['results'][0]['address_components'][1]['long_name'];
    final streetNumber =
        decodedResponse['results'][0]['address_components'][0]['long_name'];
    print('street number: $streetNumber');
    final data = {
      'address': address,
      'city': city,
      'street': street,
      'streetNumber': streetNumber
    };
    return data;
  }

  getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    print(
        'currentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocation');
    print(currentLocation);
    print(
        'currentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocationcurrentLocation');
    final formattedData =
        await getAddress(currentLocation.latitude, currentLocation.longitude);
    final address = formattedData['address'];
    final city = formattedData['city'];
    final street = formattedData['street'];
    final streetNumber = formattedData['streetNumber'];

    _locationData = LocationData(
        address: address,
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        city: city,
        street: street,
        streetNumber: streetNumber);

    return _locationData;
  }

  //launch waze
  launchWaze(index) async {
    double lat = parkings[index].location.latitude;
    double lng = parkings[index].location.longitude;
    print(lat);
    print(lng);

    try {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              Uri.encodeFull('https://waze.com/ul?ll=$lat,$lng&navigate=yes'));
      await intent.launch();
    } catch (e) {
      print(e);
    }
  }

  //launcg google street view
  launchStreetView(index) async {
    LocationData _locationData = await getUserLocation();
    double a = await calculateDistance(index);
    print(
        'calculateDistancecalculateDistancecalculateDistancecalculateDistancecalculateDistance');
    print(a);
    print(
        'calculateDistancecalculateDistancecalculateDistancecalculateDistancecalculateDistance');

    double lat = parkings[index].location.latitude;
    double lng = parkings[index].location.longitude;
    if (Platform.isAndroid) {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull("google.streetview:cbll=$lat,$lng"),
          package: 'com.google.android.apps.maps');
      await intent.launch();
      //for iphone
    }
  }

  //launch google maps
  launchMaps(index) async {
    LocationData _locationData = await getUserLocation();
    double a = await calculateDistance(index);
    print(
        'calculateDistancecalculateDistancecalculateDistancecalculateDistancecalculateDistance');
    print(a);
    print(
        'calculateDistancecalculateDistancecalculateDistancecalculateDistancecalculateDistance');

    String origin = _locationData.address; // lat,long like 123.34,68.56
    String destination = parkings[index].location.address;
    if (Platform.isAndroid) {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin +
                  "&destination=" +
                  destination +
                  "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      await intent.launch();
      //for iphone
    } else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }


  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    //image/jpg - which type
    final mimeTypeData = lookupMimeType(image.path).split('/');
    //function url
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-parkings-1f1a2.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] = 'Bearer ${_authUser.token}';

    try {
      //send the request
      final streamedResponse = await imageUploadRequest.send();
      //convert stream response to normal response
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('went wrong');
        print(json.decode(response.body));
        return null;
      }
      //if we successful
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<double> calculateDistance(int index) async {
    LocationData _getUserLocation = await getUserLocation();
    double userLat = _getUserLocation.latitude;
    double userLng = _getUserLocation.longitude;
    double parkingLat = parkings[index].location.latitude;
    double parkingLng = parkings[index].location.longitude;
    print('User address');
    print(_getUserLocation.address);
    print('parking address');

    print(parkings[index].location.address);

    double distanceBetweenPoints = await Geolocator()
        .distanceBetween(userLat, userLng, parkingLat, parkingLng);
    return distanceBetweenPoints;
  }

//add user to list if not exist
  Future<void> addUser() async {
    print("authUser id inside add users");
    print(_authUser.id);
    var containUser = _users.firstWhere(
      (user) => user.id == _authUser.id,
      orElse: () => null,
    );
    //if there is a user get the points. reports and likes
    if (containUser != null) {

      return;
    }

    final Map<String, dynamic> userData = {
      'user_id': _authUser.id,
      'user_name': _authUser.name,
      'user_email': _authUser.userEmail,
      'user_photo': _authUser.photoUrl,
      "user_likes": _authUser.likes = 0,
      "user_points": _authUser.points = 0,
      "user_reports": _authUser.reports = 0
    };

//fetch user data
    try {
      final http.Response response = await http.post(
          'https://parkings-1f1a2.firebaseio.com/users.json?auth=${_authUser.token}',
          body: json.encode(userData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      final User addedUser = User(
        id: _authUser.id,
        userFireId: responseData['name'],
        name: _authUser.name,
        userEmail: _authUser.userEmail,
        photoUrl: _authUser.photoUrl,
        token: null,
        access: null,
        likes: 0,
        points: 0,
        reports: 0,
      );
      _speUserFireId = addedUser.userFireId;
      print("user fireId");
      print(addedUser.userFireId);

      _users.add(addedUser);
      print('length after user add');
      print(_users.length);

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  

  Future fetchUsers({onlyForUser = false}) async {
    return http
        .get(
            'https://parkings-1f1a2.firebaseio.com/users.json?auth=${_authUser.token}')
        .then<Null>((http.Response response) {
      final List<User> fetchedUserList = [];
      final Map<String, dynamic> userListData = json.decode(response.body);
      if (userListData == null) {
        print("userList null");
        _users = [];

        return;
      }
      print("userList not null");
      userListData.forEach((String id, dynamic fetchedUserData) {
        print("inside for each fetch");
        print(id);
        final User user = User(
            userFireId: id,
            id: fetchedUserData['user_id'],
            name: fetchedUserData['user_name'],
            userEmail: fetchedUserData['user_email'],
            photoUrl: fetchedUserData['user_photo'],
            token: null,
            access: null,
            likes: fetchedUserData['user_likes'],
            points: fetchedUserData['user_points'],
            reports: fetchedUserData['user_reports']);
            print("after user add points:" + user.points.toString());
        fetchedUserList.add(user);
        print(user.userFireId);
        print(user.name);
        notifyListeners();
      });
      _users = fetchedUserList;

      _users.forEach((user) {
        if(user.id == _authUser.id) {
          _speUserFireId = user.userFireId;
          _authUser = User(
      id: _authUser.id,
      userEmail: _authUser.userEmail,
      token: _authUser.token,
      access: _authUser.token,
      name: _authUser.name,
      photoUrl: _authUser.photoUrl,
      userFireId: _speUserFireId,
      points: user.points,
      likes: user.likes,
      reports: user.reports
      // points: points
    );
          print( _speUserFireId);
        }
      });



      print('length before  user add');
      print(_users.length);

      for (var user in _users) {
        print(user.name);
      }
      notifyListeners();
    });
  }

  


  Future _updateData(points, reports, likes) {
    final Map<String, dynamic> updateData = {
      'user_id': _authUser.id,
      'user_name': _authUser.name,
      'user_email': _authUser.userEmail,
      'user_photo': _authUser.photoUrl,
      "user_points": points,
      "user_reports": reports,
      "user_likes": likes
    };

    

    return http.put(
        'https://parkings-1f1a2.firebaseio.com/users/${_speUserFireId}.json?auth=${_authUser.token}',
        body: json.encode(updateData),
        
        );

  
  }

  //add every time to parking list another card
//the function recive string, this string go to the text in the card
  Future addParking(String address, File image, LocationData locData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    print('dadadaaddadadaadda');
    print(uploadData['imagePath']);
    print('dadadaaddadadaadda');

    if (uploadData == null) {
      print('upload failed');
      return false;
    }

    //get the full date
    final DateTime fullDate = DateTime.now();
    //get only the time
    final String time = DateFormat.Hms().format(fullDate);

    final Map<String, dynamic> parkingData = {
      'address': address,
      'userEmail': _authUser.userEmail,
      'userId': _authUser.id,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'loc_city': locData.city,
      'loc_street': locData.street,
      'loc_street_number': locData.streetNumber,
      'time': time,
      'userName': _authUser.name
    };
    try {
      final http.Response response = await http.post(
          'https://parkings-1f1a2.firebaseio.com/parkings.json?auth=${_authUser.token}',
          body: json.encode(parkingData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      final Parking addedParking = Parking(
          id: responseData['name'],
          address: address,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          userEmail: _authUser.userEmail,
          userId: _authUser.id,
          location: locData,
          city: locData.city,
          street: locData.street,
          streetNumber: locData.streetNumber,
          time: time,
          userName: _authUser.name
          // userEmail:
          );

      _parkings.add(addedParking);
      _authUser.raisePoints();
      _authUser.raiseReports();
      _updateData(_authUser.points, _authUser.reports, _authUser.likes);
      prefs.setInt("points", _authUser.points);
      prefs.setInt("likes", _authUser.likes);
      prefs.setInt("reports", _authUser.reports);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future deleteParking(int index) async {
    final selectedId = _parkings[index].id;
    _parkings.removeAt(index);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

    notifyListeners();

    return http
        .delete(
            'https://parkings-1f1a2.firebaseio.com/parkings/${selectedId}.json?auth=${_authUser.token}')
        .then((http.Response response) {
             _authUser.decreasePoints();
             _authUser.decreaseReports();
      _updateData(_authUser.points, _authUser.reports, _authUser.likes);
      prefs.setInt("points", _authUser.points);
      prefs.setInt("likes", _authUser.likes);
      prefs.setInt("reports", _authUser.reports);
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future fetchParkings({onlyForUser = false}) async {
    _isLoading = true;

    notifyListeners();
    return http
        .get(
            'https://parkings-1f1a2.firebaseio.com/parkings.json?auth=${_authUser.token}')
        .then<Null>((http.Response response) {
      final List<Parking> fetchedParkingList = [];
      final Map<String, dynamic> parkingListData = json.decode(response.body);
      if (parkingListData == null) {
        return;
      }
      parkingListData.forEach((String parkingId, dynamic fetchedParkingData) {
        final Parking parking = Parking(
          id: parkingId,
          location: LocationData(
              address: fetchedParkingData['loc_address'],
              latitude: fetchedParkingData['loc_lat'],
              longitude: fetchedParkingData['loc_lng'],
              city: fetchedParkingData['loc_city'],
              street: fetchedParkingData['loc_street'],
              streetNumber: fetchedParkingData['loc_street_number']),
          address: fetchedParkingData['address'],
          image: fetchedParkingData['imageUrl'],
          imagePath: fetchedParkingData['imagePath'],
          userEmail: fetchedParkingData['userEmail'],
          userId: fetchedParkingData['userId'],
          time: fetchedParkingData['time'],
          userName: fetchedParkingData['userName'],
        );
        fetchedParkingList.add(parking);
        _isLoading = false;
        notifyListeners();
      });

      _parkings = onlyForUser
          ? fetchedParkingList.where((Parking parking) {
              print('user id ${_authUser.id}');
              print('parking id ${parking.userId}');
              return parking.userId == _authUser.id;
            }).toList()
          : fetchedParkingList;
      notifyListeners();
    });
  }

  Future<FirebaseUser> facebookSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final facebookLogin = FacebookLogin();
    final facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult.accessToken.token}');

        final profile = json.decode(graphResponse.body);

        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);

        final FirebaseUser fireUser =
            await _auth.signInWithCredential(credential);
        final token = await fireUser.getIdToken();

        print(profile.toString());
        print("LoggedIn");
        _authUser = User(
            id: fireUser.uid,
            access: facebookLoginResult.accessToken.token,
            name: fireUser.displayName,
            token: token,
            userEmail: fireUser.email,
            photoUrl: fireUser.photoUrl);

        prefs.setString('email', _authUser.userEmail);
        prefs.setString('userId', _authUser.id);
        prefs.setString('accessToken', _authUser.access);
        prefs.setString('userName', _authUser.name);
        prefs.setString('userPhoto', _authUser.photoUrl);

        _userSubject.add(true);

        notifyListeners();
        print("logged in");
        print(fireUser);
        return fireUser;
        break;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    final FirebaseUser fireUser = await _auth.signInWithCredential(credential);
    print(fireUser.displayName);
    var token = await fireUser.getIdToken();
    var points = prefs.getInt("points");
  
 
    // var refreshedToken = await fireUser.getIdToken();
    _authUser = User(
      id: fireUser.uid,
      userEmail: fireUser.email,
      token: token,
      access: googleSignInAuthentication.accessToken,
      name: fireUser.displayName,
      photoUrl: fireUser.photoUrl,
      // points: points
    );
    prefs.setString('email', _authUser.userEmail);
    prefs.setString('userId', _authUser.id);
    prefs.setString('accessToken', _authUser.access);
    prefs.setString('userName', _authUser.name);
    prefs.setString('userPhoto', _authUser.photoUrl);

    _userSubject.add(true);
    print('user id:');
    print(fireUser.uid);
    print('user points:');
    print(points.toString());

    // print(_authUser.points);
    await fetchUsers();
    await addUser();
    notifyListeners();

    return fireUser;
  }

  Future signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.clear();
      prefs.setInt("points", _authUser.points);
      prefs.setInt("likes", _authUser.likes);
      prefs.setInt("reports", _authUser.reports);
      String points = prefs.getInt("points").toString();
      print("logout points" + points);
    await FirebaseAuth.instance.signOut();
    // TODO: לעשות ניתוק פרטני לכל אפשרות
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    // final points = _authUser.points;
    // prefs.setInt('points', points);
    // print('user points:');
    // print(_authUser.points);


    _authUser = null;
  
    // prefs.remove("email");
    // prefs.remove("userId");
    // prefs.remove("accessToken");
    // prefs.remove("userName");
    // prefs.remove("userPhoto");

    _userSubject.add(false);

    notifyListeners();
    print('signed out');
  }

//   void autoAuth() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String token = prefs.getString('accessToken');
//     if (token != null) {
//       final String userEmail = prefs.getString('email');
//       final String userId = prefs.getString('userId');
//       final String tokenid = prefs.getString('idToken');
//       _auth.
//       _authUser = User(id: userId, userEmail: userEmail, token: token);
//       notifyListeners();
//     }
//   }

// //TIME OUT - REPLACE
//   void setTimeOut(int time) {
//             user.;

// }

  void autoAuth() async {
    var current = await FirebaseAuth.instance.currentUser();

    if (current == null) {
      _userSubject.add(false);
      notifyListeners();
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEmail = prefs.getString('email');
    final String userId = prefs.getString('userId');
    final String userAccess = prefs.getString('accessToken');
    final String userName = prefs.getString('userName');
    final String userPhoto = prefs.getString('userPhoto');
    int userPoints = prefs.getInt('points');
    int userLikes = prefs.getInt('likes');
    int userReports = prefs.getInt('reports');

    var refreshedToken = await current.getIdToken(refresh: true);
    _authUser = User(
        id: userId,
        userEmail: userEmail,
        token: refreshedToken,
        access: userAccess,
        name: userName,
        photoUrl: userPhoto,
        points: userPoints,
        likes: userLikes,
        reports: userReports
        // points: userPoints
        );
    // print(current);
    // print(_authUser.id);
    // print(_authUser.userEmail);
    // print(_authUser.token);
    _userSubject.add(true);
    // print(_authUser.points);
    fetchUsers();
    notifyListeners();
  }
}
