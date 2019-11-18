import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/connected_parking.dart';

class UserList extends StatelessWidget {
  final ConnectedParkingModel model;

  UserList(this.model);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: model.users.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildUserCard(context, index, model);
          },
        )

        //  Column(
        //   children: <Widget>[PageBody()],
        // ),
        );
  }
}

Widget _buildUserCard(
    BuildContext context, int index, ConnectedParkingModel model) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.22,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //content
        Positioned(
          top: 80.0,
          right: 30.0,
          left: 30.0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
                // color: Color(0XFF2196F3),
                color: Colors.blue),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                    // border: Border(
                    //   right: BorderSide(width: 1.0, color: Colors.white24),
                    // ),
                    ),
                child: Text((index + 1).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0)),
              ),
              title: Center(
                child: Text(
                  model.users[index].name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

              // subtitle: Row(
              //   children: <Widget>[
              //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
              //     Text(
              //       " Intermediate",
              //       style: TextStyle(color: Colors.white),
              //     )
              //   ],
              // ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Points',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('93',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0))
                ],
              ),
            ),
          ),
        ),
        //image
        Positioned(
          top: 20,
          // child: Container(
          //   height: 100,
          //   width: 100,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     shape: BoxShape.circle,
          //     border: Border.all(color: Colors.blue, width: 13.0),
          //   ),
          //   child: Image.network(model.users[index].photoUrl,
          // fit: BoxFit.fill
          //   ),
          // ),
          // child: CircleAvatar(

          //   radius: 45,
          //   backgroundImage: NetworkImage(model.users[index].photoUrl),
          // ),
          child: new Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: NetworkImage(model.users[index].photoUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.blue,
                width: 13.0,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

// Stack(
//     children: <Widget>[
//       Card(
//         elevation: 8.0,
//         margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//         child: Container(
//           decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
//           child: ListTile(
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             leading: Container(
//               padding: EdgeInsets.only(right: 12.0),
//               decoration: BoxDecoration(
//                   // border: Border(
//                   //   right: BorderSide(width: 1.0, color: Colors.white24),
//                   // ),
//                   ),
//               child: Text((index + 1).toString(),
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 28.0)),
//             ),
//             title: Center(
//               child: Text(
//                 model.users[index].name,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.0),
//               ),
//             ),
//             // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

//             // subtitle: Row(
//             //   children: <Widget>[
//             //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
//             //     Text(
//             //       " Intermediate",
//             //       style: TextStyle(color: Colors.white),
//             //     )
//             //   ],
//             // ),
//             trailing: Column(
//               children: <Widget>[
//                 Text(
//                   'Points',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20.0),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Text('93',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20.0))
//               ],
//             ),
//           ),
//         ),
//       ),
//       Positioned(
//         right: MediaQuery.of(context).size.width/2,
//         top: 10,
//               child: Container(
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(
//             color: Colors.black,
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white, width: 5.0),
//           ),
//         ),
//       ),
//     ],
//   );
