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
          Expanded(
            child: ARKitSceneView(
              showFeaturePoints: true,
              enablePanRecognizer: true,
              enableRotationRecognizer: true,
              planeDetection: ARPlaneDetection.horizontal,
              onARKitViewCreated: onARKitViewCreated,
            ),
          ),
//          Container(
//            height: 80,
//            child: Flex(
//              direction: Axis.horizontal,
//              children: <Widget>[
//                Expanded(
//                  child: Row(
//                    children: <Widget>[
//                      RaisedButton(
//                        onPressed: () {
//                          node.rotation.value += vector.Vector4(20, 0, 0, 0);
////                        node.rotation.value += vector.Vector4(0, 0, 0, 5);
////                        node.eulerAngles.value += vector.Vector3(0, 0, 5);
//                        },
//                        child: Text("awdawd"),
//                      ),
//                      RaisedButton(
//                        onPressed: () {},
//                        child: Text("awdawd"),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ),
          /* Container(
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
          )*/
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
    this.arkitController.onNodePan = (pan) => _onPanHandler(pan);
    this.arkitController.onNodeRotation =
        (rotation) => _onRotationHandler(rotation);
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitPlaneAnchor)) {
      return;
    }
    _addPlane(arkitController, anchor);
  }

  void _onPanHandler(List<ARKitNodePanResult> pan) {
    final panNode =
        pan.firstWhere((e) => e.nodeName == node.name, orElse: null);
    if (panNode != null) {
      final old = node.eulerAngles.value;
      final newAngleY = panNode.translation.x * math.pi / 180;
      node.eulerAngles.value = vector.Vector3(old.x, newAngleY, old.z);
    }
  }

  void _onRotationHandler(List<ARKitNodeRotationResult> rotation) {
    final rotationNode = rotation.firstWhere(
      (e) => e.nodeName == node.name,
      orElse: () => null,
    );
    print(node.rotation.value);
    if (rotationNode != null) {
      final rotation =
          node.rotation.value + vector.Vector4.all(rotationNode.rotation);
      node.rotation.value = rotation;
    }
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
    String currentImage = this.widget.chosenTiles[0].substring(51, 56);
    print(this.widget.chosenTiles[0].substring(51, 56));

    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(
              image: 'assets/$currentImage.png', color: Colors.white),
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
