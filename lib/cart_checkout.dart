import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class CartCheckout extends StatelessWidget {
//  Map<String, String> orderInfo;
  String orderInfo = '';

  CartCheckout(orderInfo);

  String bodyText = "";

  var inputValues = {
    'Ім\'я': '',
    'Прізвище': '',
    'Пошта': '',
    'Номер телефону': '',
    'Інше': '',
  };

  final List<String> formTitles = const [
    'Ім\'я',
    'Прізвище',
    'Пошта',
    'Номер телефону',
    'Інше',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: inputValues.toString() + orderInfo.toString(),
      subject: "Замовлення від " + inputValues['Ім\'я'] + " " + inputValues['Прізвище'],
      recipients: ["lukatriska@gmail.com"],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print("orderinfo in cart checkout: ");
    print(orderInfo);
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: formTitles
                .map((formTitle) => Form(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 40,
                        child: Platform.isIOS
                            ? CupertinoTextField(
                                onChanged: (text) {
                                  inputValues[formTitle] = text;
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: formTitle == 'Номер телефону'
                                    ? TextInputType.phone
                                    : null,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                placeholder: formTitle,
                              )
                            : TextFormField(
                                onChanged: (text) {
                                  inputValues[formTitle] = text;
                                  print(inputValues);
                                  print(orderInfo);
                                },
                                keyboardType: formTitle == 'Номер телефону'
                                    ? TextInputType.phone
                                    : null,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: formTitle,
                                ),
                              ),
                      ),
                    ))
                .toList(),
          ),
          Platform.isIOS
              ? CupertinoButton.filled(
                  child: Text("Надіслати замовлення"),
                  onPressed: () => send(),
                )
              : RaisedButton(
                  child: Text("Надіслати замовлення"),
                  onPressed: () => send(),
                ),
        ],
      ),
    );
  }
}
