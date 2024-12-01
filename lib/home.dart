import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add.dart';
import 'cards.dart';
import 'list_all.dart';
import 'list_current.dart';
import 'list_order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget forBody = const ListPolicy();

  final Stream<QuerySnapshot> policiesStream =
      FirebaseFirestore.instance.collection('policies').snapshots();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.green,
    );

    return StreamBuilder(
      stream: policiesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Center(child: Text("Policy Manager")),
            ),
            body: const Center(
              child: Text(
                "ERROR: Close the app and try again...",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List policiesdocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> policy = document.data() as Map<String, dynamic>;
          policiesdocs.add(policy);
          policy['id'] = document.id;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Policy Manager"),
            actions: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AddPolicy()),
                          );
                        },
                        style: style,
                        child: const Text("Add"),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3)),
                    ],
                  )),
            ],
          ),
          body: forBody,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture: Image.asset(
                      "assets/images/myself/myself.jpg",
                    ),
                    currentAccountPictureSize: const Size.fromRadius(50),
                    accountName: const Text("Manchharam Kumhar"),
                    accountEmail: const Text("LIC Advisor"),
                  ),
                ),
                ListTile(
                  title: const Text("All policies"),
                  onTap: () {
                    setState(
                      () {
                        forBody = const ListPolicy();
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Policies in order"),
                  onTap: () {
                    setState(
                      () {
                        forBody = const ListOrder();
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Current month Policies"),
                  onTap: () {
                    setState(
                      () {
                        forBody = const ListCurrent();
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Cards"),
                  onTap: () {
                    setState(
                      () {
                        forBody = const FestivalCards();
                      },
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Totlal Policies"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Total Policies: "),
                          content: Text(policiesdocs.length.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                // ListTile(
                //   title: const Text("Search"),
                //   onTap: () {
                //     // Navigator.pop(context);
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             SearchPolicy(policyList: policiesdocs),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
