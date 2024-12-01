import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policy_management_app/search.dart';
import 'package:policy_management_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ListPolicy extends StatefulWidget {
  const ListPolicy({super.key});
  @override
  // ListPolicyState createState() {
  //   return ListPolicyState();
  // }
  State<ListPolicy> createState() => ListPolicyState();
}

class ListPolicyState extends State<ListPolicy> {
  // final _listformkey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> policiesStream = FirebaseFirestore.instance
      .collection('policies')
      .orderBy('createdAt', descending: true)
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
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> policy = document.data() as Map<String, dynamic>;
          policiesdocs.add(policy);
          policy['id'] = document.id;
        }).toList();

        if (policiesdocs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "No policies to display...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                Text(
                  "Tap ADD button to add policies...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("List of all Policies"),
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
                                Text(policiesdocs[index]['name']),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Text(policiesdocs[index]['policy_number']),
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
                                        .format(
                                            policiesdocs[index]['dnr'].toDate())
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
                                              id: policiesdocs[index]['id']),
                                        ),
                                      );
                                    },
                                    child: const Text("View"),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3)),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Delete Policy ?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deletePolicy(
                                                        policiesdocs[index]
                                                            ['id']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text("Delete"),
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
                                          "${policiesdocs[index]['name']}\n"
                                          "Policy No.: ${policiesdocs[index]['policy_number']}\n"
                                          "Renewal Date: ${DateFormat('MMM d, y').format(policiesdocs[index]['dnr'].toDate()).toString()}\n"
                                          "Sum Assured: ${policiesdocs[index]['sum_assured']}\n"
                                          "Nominee: ${policiesdocs[index]['nominee']}\n"
                                          "Mode of Payment: ${policiesdocs[index]['mode']}\n"
                                          "Date of Commencement: ${DateFormat('MMM d, y').format(policiesdocs[index]['doc'].toDate()).toString()}\n"
                                          "Date of Maturity: ${DateFormat('MMM d, y').format(policiesdocs[index]['dom'].toDate()).toString()}\n"
                                          "Plan name: ${policiesdocs[index]['plan_name']}\n"
                                          "Table and term: ${policiesdocs[index]['table_and_term']}\n"
                                          "\nThank You!";
                                      Share.share(message);
                                    },
                                    child: const Text("Share"),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      // tileColor: Colors.green,
                    ),
                  );
                },
                childCount: policiesdocs.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
