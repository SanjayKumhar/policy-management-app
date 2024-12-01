import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policy_management_app/search.dart';
import 'package:policy_management_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ListCurrent extends StatefulWidget {
  const ListCurrent({super.key});
  @override
  // ListCurrentState createState() {
  //   return ListCurrentState();
  // }
  State<ListCurrent> createState() => ListCurrentState();
}

class ListCurrentState extends State<ListCurrent> {
  final Stream<QuerySnapshot> policiesStream = FirebaseFirestore.instance
      .collection('policies')
      .orderBy('name', descending: false)
      .snapshots();

  CollectionReference policies =
      FirebaseFirestore.instance.collection('policies');

  Future<void> deletePolicy(id) {
    return policies.doc(id).delete().then((value) {}).catchError((error) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ERROR occured:"),
              content: Text("Close app and try again: $error"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: policiesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "ERROR: Close the app and try again...",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List policiesdocs = [];
        List filterpoliciesdocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> policy = document.data() as Map<String, dynamic>;
          policiesdocs.add(policy);
          policy['id'] = document.id;
        }).toList();

        DateTime today = DateTime.now();
        // int days = DateTime(today.year, today.month + 1, 0).day;//to get the number of days in current month

        int currentMonth = today.month;

        for (int i = 0; i < policiesdocs.length; i++) {
          if (((policiesdocs[i]['dnr'].toDate()).month == currentMonth)) {
            filterpoliciesdocs.add(policiesdocs[i]);
          }
        }

        if (filterpoliciesdocs.isEmpty) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "No policies in current month,",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 3)),
              Text(
                "whose premium needs to be paid...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ));
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("List of current month Policies"),
              actions: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: (() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPolicy(policyList: policiesdocs)),
                            );
                          }),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: const Icon(Icons.search),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3)),
                      ],
                    )),
              ],
              floating: true,
              pinned: true,
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(filterpoliciesdocs[index]['name']),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Text(
                                    filterpoliciesdocs[index]['policy_number']),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Date of next renewal: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(DateFormat('MMM d, y')
                                        .format(filterpoliciesdocs[index]['dnr']
                                            .toDate())
                                        .toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                              child: Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ViewPolicy(
                                              id: filterpoliciesdocs[index]
                                                  ['id']),
                                        ),
                                      );
                                    },
                                    child: const Text("View"),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                  ),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      String message =
                                          "${filterpoliciesdocs[index]['name']}\n"
                                          "Policy No.: ${filterpoliciesdocs[index]['policy_number']}\n"
                                          "Renewal Date: ${DateFormat('MMM d, y').format(filterpoliciesdocs[index]['dnr'].toDate()).toString()}"
                                          "\nThank You!";
                                      Share.share(message);
                                    },
                                    child: const Text("Share"),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                  ),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 221, 151, 0)),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Premium Paid ?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          });
                                      // deletePolicy(
                                      //     filterpoliciesdocs[index]['id']);
                                    },
                                    child: const Text("Paid"),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      // tileColor: Colors.green,
                    ),
                  );
                },
                childCount: filterpoliciesdocs.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
