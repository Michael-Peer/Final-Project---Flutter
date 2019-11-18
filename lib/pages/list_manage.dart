import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';
import 'package:parking_location/classes/parkingModel.dart';
import 'package:parking_location/pages/small_list.dart';
import 'package:search_widget/search_widget.dart';
import 'package:search_widget/widget/no_item_found.dart';

import 'all_parkings_list.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/connected_parking.dart';
import '../widgets/drawer.dart';

class ListManager extends StatefulWidget {
  final ConnectedParkingModel model;

  ListManager(this.model);

  @override
  _ListManagerState createState() => _ListManagerState();
}

class _ListManagerState extends State<ListManager> {
  final _formKey = new GlobalKey<FormState>();
  String _name = 'No one';
  List<Parking> _dupList;
  TextEditingController _textController;

  @override
  void initState() {
    widget.model.fetchParkings();
    _textController = TextEditingController();
    _dupList = widget.model.parkings;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Parking> _parkings = widget.model.parkings;

    // _buildMaterialSearchPage(BuildContext context) {
    //   return MaterialPageRoute<String>(
    //     settings: RouteSettings(
    //       name: 'Material Search',
    //       isInitialRoute: false
    //     ),
    //     builder: (BuildContext context) {
    //       return Material(
    //         child: MaterialSearch<String>(
    //           placeholder: 'Search',
    //           results: ,
    //         )
    //       )
    //     }
    //   )
    // }

    // _showMaterialSearch(BuildContext context) {
    //   Navigator.of(context).push(_buildMaterialSearchPage(context))
    //   .then((String value) {
    //     setState(() {
    //      _name = value.toString();
    //     });
    //   });
    // }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[900],
          elevation: 0.0,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Big list',
                icon: Icon(Icons.featured_play_list),
              ),
              Tab(
                text: 'Small list',
                icon: Icon(Icons.list),
              )
            ],
          ),
          // actions: <Widget>[
          //   IconButton(
          //     onPressed: () {
          //       _showMaterialSearch(context);
          //     },
          //     tooltip: "Search",
          //     icon: Icon(Icons.search),
          //   )
          // ],
          title: Text("Parkings List")
        ),
        // drawer:Drawer(
        //   child: Column(children: <Widget>[
        //               SearchWidget<Parking>(
        //         dataList: model.parkings,
        //         hideSearchBoxWhenItemSelected: false,
        //         listContainerHeight: MediaQuery.of(context).size.height / 4,
        //         queryBuilder: (String query, List<Parking> parkings) {
        //           return parkings.where((Parking parking) => parking.city.toLowerCase().contains(query.toLowerCase())).toList();
        //         },
        //         popupListItemBuilder:  (Parking parking) {
        //         return PopupListItemWidget(parking);
        //         },
        //         selectedItemBuilder: (Parking selectedParking, VoidCallback deleteSelectedItem) {
        //           return SelectedItemWidget(selectedParking, deleteSelectedItem);
        //         },
        //         noItemsFoundWidget: NoItemFound(),
        //         textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
        //           return MyTextField(controller, focusNode);
        //         },
        //       )
        //   ],),
        // ),
        body: TabBarView(
          children: <Widget>[
            AllParkings(widget.model),
            SmallList(widget.model)
          ],
        ),
      ),
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  final Parking item;

  PopupListItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        item.city,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class SelectedItemWidget extends StatelessWidget {
  final Parking selectedItem;
  final VoidCallback deleteSelectedItem;

  SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 4.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.city,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  MyTextField(this.controller, this.focusNode);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: new TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x4437474F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "blablabla...",
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}
