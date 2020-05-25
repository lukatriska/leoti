import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:leoti/ar_screen.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

Future<Album> fetchAlbum() async {
  final response =
      await http.get('http://127.0.0.1:8000/assets/l-101.png');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(json.decode(response.body));
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}



class Album {
  final String name;
  final String title;

  Album({this.name, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      title: json['title'],
    );
  }
}

void main() async {
//  WidgetsFlutterBinding.ensureInitialized();

//  Crashlytics.instance.enableInDevMode = true;
//
//  // Pass all uncaught errors from the framework to Crashlytics.
//  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

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

class _HomePageState extends State<HomePage> {
//  Future<Album> futureAlbum;
//  @override
//  void initState() {
//    super.initState();
//    futureAlbum = fetchAlbum();
//  }
  List loftTiles = new List<int>.generate(24, (i) => i + 1);

  List<String> _selectedImages = [];

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
    Widget gridViewSelection = GridView.count(
      childAspectRatio: 1.0,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      children: loftTiles.map((imageNumber) {
        String currentImage = imageNumber < 10
            ? 'http://leoti.com.ua/files/collections/loft/img_6x6/l-10$imageNumber\_6x6_v1.png'
            : 'http://leoti.com.ua/files/collections/loft/img_6x6/l-1$imageNumber\_6x6_v1.png';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('LEOTI'),
      ),
      body:

      /*Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.title);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      )*/

      Column(
        children: <Widget>[
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
      )
      ,
//      bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.shopping_cart),
//            title: Text('Cart'),
//          ),
//        ],
////        currentIndex: _selectedIndex,
////        selectedItemColor: Colors.amber[800],
////        onTap: _onItemTapped,
//      ),
    );
  }
}
