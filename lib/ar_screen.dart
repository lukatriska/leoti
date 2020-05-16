import 'dart:io';

import 'package:arkit_plugin/arkit_node.dart';
import 'package:arkit_plugin/geometries/arkit_sphere.dart';
import 'package:arkit_plugin/widget/arkit_scene_view.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoti/cart_checkout.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'dart:math' as math;

class ArScreen extends StatefulWidget {
  List<String> chosenTiles = [];

  ArScreen(this.chosenTiles);

  @override
  _ArScreenState createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  var orderInfo = <String, String>{};

  /*void goToCartCheckout(BuildContext ctx, orderInfo) {
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
  }*/

  ARKitController arkitController;
  ARKitPlane plane;
  ARKitNode node;
  String anchorId;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    String currentTile = this.widget.chosenTiles[0];

    print(this.widget.chosenTiles);
    return Scaffold(
      appBar: AppBar(title: const Text('AR')),
      body: Column(
        children: <Widget>[
          Container(
            child: Expanded(
              child: ARKitSceneView(
                showFeaturePoints: true,
                planeDetection: ARPlaneDetection.horizontal,
                onARKitViewCreated: onARKitViewCreated,
              ),
            ),
          ),
          Container(
            height: 100,
            child: Row(
                children: this.widget.chosenTiles.map((currentImage) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(currentImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: CheckboxListTile(value: true ? currentImage == this.widget.chosenTiles[0] : false, onChanged: (bool val) {}
//    {
//                        setState(() {
//                          this.widget.chosenTiles.contains(currentImage)
//                              ? this.widget.chosenTiles.remove(currentImage)
//                              : this.widget.chosenTiles.add(currentImage);
//                        });
//                        print(this.widget.chosenTiles);
//                      },
                      ),
                ),
              );
            }).toList()),
          )
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId) {
      return;
    }
    final ARKitPlaneAnchor planeAnchor = anchor;
    node.position.value =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(
              image: 'assets/l-101.png', color: Colors.white),
        )
      ],
    );

    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    controller.add(node, parentNodeName: anchor.nodeName);
  }

/*@override
  Widget build(BuildContext context) {
    var inputValues = <String, String>{};

    List<Widget> listOfTileWidgets = List<Widget>();

//    TODO bind the textformfield's value to the tile id where it exists

*/ /*    for (int i = 0; i < this.widget.chosenTiles.length; i++) {
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
    }*/ /*

    print(this.widget.chosenTiles);
    return Scaffold(
//      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("AR Screen"),
      ),
      body: Container(
        child: Text("Container Child"),
      ),
    );
  }*/
}
