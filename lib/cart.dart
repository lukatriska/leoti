import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoti/cart_checkout.dart';

class Cart extends StatefulWidget {
  List<String> chosenTiles = [];

  Cart(this.chosenTiles);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var orderInfo = <String, String>{};

  void goToCartCheckout(BuildContext ctx, orderInfo) {
    Navigator.of(ctx).push(
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (_) => CartCheckout(orderInfo),
            )
          : MaterialPageRoute(
              builder: (_) {
                print("orderinfo in cart: " + orderInfo.toString());
                return CartCheckout("orderInfoSTRING");
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var inputValues = <String, String>{};

    List<Widget> listOfTileWidgets = List<Widget>();

//    TODO bind the textformfield's value to the tile id where it exists

    for (int i = 0; i < this.widget.chosenTiles.length; i++) {
      listOfTileWidgets.add(
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(237, 237, 237, 100),
            image: DecorationImage(
                image: ExactAssetImage(this.widget.chosenTiles[i]),
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomLeft),
          ),
          alignment: Alignment.bottomRight,
          child: Column(
            children: <Widget>[
              Text(
                "L" + this.widget.chosenTiles[i].substring(8, 12),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                child: Container(
                  width: 70,
                  padding: EdgeInsets.only(left: 0, top: 20),
                  child: Platform.isIOS
                      ? CupertinoTextField(
                          onChanged: (text) {
                            orderInfo[this.widget.chosenTiles[i]] = text;
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          placeholder: 'кв. м',
                        )
                      : TextFormField(
                          onChanged: (text) {
                            orderInfo[this.widget.chosenTiles[i]] = text;
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'кв. м',
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      );
    }

    print(this.widget.chosenTiles);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              childAspectRatio: 3.0,
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              children: listOfTileWidgets,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Platform.isIOS
                ? CupertinoButton.filled(
                    child: Text("Продовжити"),
                    onPressed: () => goToCartCheckout(context, orderInfo),
                  )
                : RaisedButton(
                    onPressed: () => goToCartCheckout(context, orderInfo),
                    child: Text("Продовжити"),
                  ),
          ),
        ],
      ),
    );
  }
}
