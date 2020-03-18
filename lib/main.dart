import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
  List loftTiles = new List<int>.generate(24, (i) => i + 1);

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
      children: loftTiles.map((imageNumber) {
        String currentImage = imageNumber < 10
            ? 'assets/l-10$imageNumber.png'
            : 'assets/l-1$imageNumber.png';
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(currentImage),
              fit: BoxFit.cover,
            ),
          ),
          child: CheckboxListTile(
            value: _selectedImages.contains(currentImage),
            onChanged: (bool val) {
              setState(() {
                _selectedImages.contains(currentImage)
                    ? _selectedImages.remove(currentImage)
                    : _selectedImages.add(currentImage);
              });
              print(_selectedImages);
            },
          ),
        );
      }).toList(),
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
            padding: EdgeInsets.only(bottom: 25, top: 15),
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
