import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  List<String> chosenTiles = [];
  final List<String> formTitles = const [
    'Ім\'я',
    'Прізвище',
    'Пошта',
    'Номер телефону',
    'Інше',
  ];

  Cart(this.chosenTiles);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(this.chosenTiles);
    return Scaffold(
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
              children: this
                  .chosenTiles
                  .map((chosenTile) => Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(237, 237, 237, 100),
                          image: DecorationImage(
                              image: ExactAssetImage(chosenTile),
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.bottomLeft),
                        ),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "L" + chosenTile.substring(8, 12),
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
                                child: TextFormField(
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
                      ))
                  .toList(),
            ),
          ),
          Container(
//            padding: EdgeInsets.only(bottom: 40),
            child: RaisedButton(
              child: Text("Надіслати замовлення"),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Column(
              children: formTitles
                  .map((formTitle) => Form(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 40,
                          child: TextFormField(
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
          ),
        ],
      ),
    );
  }
}
