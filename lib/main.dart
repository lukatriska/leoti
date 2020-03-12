import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart.dart';

void main() => runApp(MyApp());

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
  final List<String> _images = [
    'assets/l-101.png',
    'assets/l-102.png',
    'assets/l-103.png',
    'assets/l-104.png',
    'assets/l-105.png',
    'assets/l-106.png',
    'assets/l-107.png',
    'assets/l-108.png',
  ];

  List<String> _selectedImages = [];

  void goToCheckout(BuildContext ctx, selected) {
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

  @override
  Widget build(BuildContext context) {
    Widget gridViewSelection = GridView.count(
      childAspectRatio: 1.0,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      children: _images
          .map((imageData) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(imageData),
                    fit: BoxFit.cover,
                  ),
                ),
                child: CheckboxListTile(
                  value: _selectedImages.contains(imageData),
                  onChanged: (bool val) {
                    setState(() {
                      _selectedImages.contains(imageData)
                          ? _selectedImages.remove(imageData)
                          : _selectedImages.add(imageData);
                    });
                    print(_selectedImages);
                  },
                ),
              ))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('LEOTI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: gridViewSelection,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Platform.isIOS
                ? CupertinoButton.filled(
                    child: Text("Proceed to checkout"),
                    onPressed: () => goToCheckout(context, _selectedImages),
                  )
                : RaisedButton(
                    onPressed: () => goToCheckout(context, _selectedImages),
                    child: Text("Proceed to checkout"),
                  ),
          )
        ],
      ),
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
