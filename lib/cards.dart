// ignore_for_file: constant_identifier_names

import 'dart:convert';
// import 'dart:html';

import 'package:policy_management_app/card_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FestivalCards extends StatefulWidget {
  // final List imagess;
  const FestivalCards({super.key});
  @override
  State<FestivalCards> createState() => FestivalCardsState();
}

// ignore: camel_case_types
enum cardTypes { nothing, Diwali, NewYear }

class FestivalCardsState extends State<FestivalCards> {
  List someDiwaliImages = [];
  List someNewYearImages = [];
  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines
    final imageDiwaliPaths = manifestMap.keys
        .where((String key) => key.contains('images/Diwali/'))
        .where((String key) => key.contains('.jpg'))
        .toList();
    final imageNewYearPaths = manifestMap.keys
        .where((String key) => key.contains('images/Newyear/'))
        .where((String key) => key.contains('.jpg'))
        .toList();
    someDiwaliImages = imageDiwaliPaths;
    someNewYearImages = imageNewYearPaths;
  }

  cardTypes? _card = cardTypes.nothing;
  Widget cardButton = const Center(
    child: Text(
      "Select any one of the above card type.",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    _initImages();
    return ListView(
      // scrollDirection: Axis.horizontal,
      children: <Widget>[
        RadioListTile(
          title: const Text("Diwali"),
          value: cardTypes.Diwali,
          groupValue: _card,
          onChanged: ((cardTypes? value) => setState(() {
                _card = value;
                if (someDiwaliImages.isEmpty) {
                  cardButton = const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  cardButton = Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      for (int i = 0; i < someDiwaliImages.length; i++) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TextCard(path: someDiwaliImages[i])),
                            );
                          },
                          child: Image.asset(
                            someDiwaliImages[i],
                            width: 100,
                            height: 100,
                          ),
                        )
                      ]
                    ],
                  );
                }
              })),
        ),
        RadioListTile(
          selected: false,
          title: const Text("New Year"),
          value: cardTypes.NewYear,
          groupValue: _card,
          onChanged: ((cardTypes? value) => setState(() {
                _card = value;
                if (someNewYearImages.isEmpty) {
                  cardButton = const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  cardButton = Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      for (int i = 0; i < someNewYearImages.length; i++) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TextCard(path: someNewYearImages[i])),
                            );
                          },
                          child: Image.asset(
                            someNewYearImages[i],
                            width: 100,
                            height: 100,
                          ),
                        )
                      ]
                    ],
                  );
                }
              })),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: SingleChildScrollView(
            child: cardButton,
          ),
        )
      ],
    );
  }
}
