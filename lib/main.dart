import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoti/ar_screen.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

void main() async => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selectable GridView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class Tile {
  int id;
  String name;

  Tile.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class _HomePageState extends State<HomePage> {

  List<String> _selectedImages = [];

  Widget gridViewSelection;

  Future<List<Tile>> getTiles() async {
    var response = await http.get("http://127.0.0.1:8080/products.json");
    List<Tile> loftTiles;

    List res = json.decode(response.body);
    loftTiles = res.map((data) => Tile.fromJsonMap(data)).toList();

    gridViewSelection = GridView.count(
      childAspectRatio: 1.0,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      children: loftTiles.map((tile) {
        String currentImage = tile.id < 10
            ? 'http://leoti.com.ua/files/collections/loft/img_6x6/l-10${tile.id}\_6x6_v1.png'
            : 'http://leoti.com.ua/files/collections/loft/img_6x6/l-1${tile.id}\_6x6_v1.png';
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(currentImage),
              fit: BoxFit.cover,
            ),
          ),
          child: CheckboxListTile(
            value: _selectedImages.contains(currentImage),
            onChanged: (bool val) {
              print(_selectedImages);
              setState(() {
                _selectedImages.contains(currentImage)
                    ? _selectedImages.remove(currentImage)
                    : _selectedImages.add(currentImage);
              });
            },
          ),
        );
      }).toList(),
    );
    return loftTiles;
  }

  @override
  void initState() {
    super.initState();
    getTiles();
  }


  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("Please select at least one product to continue."),
            ));
  }

  void goToCheckout(BuildContext ctx, selected) {
    if (selected.isEmpty) {
      showAlert(context);
    } else {
      Navigator.of(ctx).push(
        Platform.isIOS
            ? CupertinoPageRoute(
                builder: (_) => Cart(selected),
              )
            : MaterialPageRoute(
                builder: (_) => Cart(selected),
              ),
      );
    }
  }

  void goToAR(BuildContext ctx, selected) {
    if (selected.isEmpty) {
      showAlert(context);
    } else {
      Navigator.of(ctx).push(
        Platform.isIOS
            ? CupertinoPageRoute(
                builder: (_) => ArScreen(selected),
              )
            : MaterialPageRoute(
                builder: (_) => ArScreen(selected),
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('LEOTI'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text("Selected images: ${_selectedImages.map((e) => e.substring(51, 56))}"),
          ),
          Expanded(
            child: gridViewSelection,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 25, top: 15),
            child: Column(
              children: <Widget>[
                Platform.isIOS
                    ? Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CupertinoButton.filled(
                          child: Text("View in AR"),
                          onPressed: () => goToAR(context, _selectedImages),
                        ),
                      )
                    : RaisedButton(
                        onPressed: () => goToAR(context, _selectedImages),
                        child: Text("View in AR"),
                      ),
                Platform.isIOS
                    ? CupertinoButton.filled(
                        child: Text("Proceed to checkout"),
                        onPressed: () => goToCheckout(context, _selectedImages),
                      )
                    : RaisedButton(
                        onPressed: () => goToCheckout(context, _selectedImages),
                        child: Text("Proceed to checkout"),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
