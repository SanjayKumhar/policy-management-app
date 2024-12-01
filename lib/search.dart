// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policy_management_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'add.dart';

class SearchPolicy extends StatefulWidget {
  final List policyList;
  const SearchPolicy({super.key, required this.policyList});
  @override
  State<SearchPolicy> createState() => SearchPolicyState();
}

class SearchPolicyState extends State<SearchPolicy> {
  final ButtonStyle style = TextButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.green,
  );

  List filterResult = [];
  String query = "";
  late Widget searchedPolicy;

  final Stream<QuerySnapshot> policiesStream = FirebaseFirestore.instance
      .collection('policies')
      // .orderBy('createdAt', descending: true)
      .snapshots();

  CollectionReference policies =
      FirebaseFirestore.instance.collection('policies');

  @override
  void initState() {
    filterResult = widget.policyList;
    if (filterResult.isEmpty) {
      searchedPolicy = const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 50),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              "No Policies, Go add them...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      searchedPolicy = SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10),
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
                          Text(filterResult[index]['name']),
                          const Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Text(filterResult[index]['policy_number']),
                          const Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date of next renewal: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(filterResult[index]['dnr'].toDate())
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
                                        id: filterResult[index]['id']),
                                  ),
                                );
                              },
                              child: const Text("View"),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3)),
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                deletePolicy(
                                    filterResult[index]['id'], index, query);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            );
          },
          childCount: filterResult.length,
        ),
      );
    }
    super.initState();
  }

  Future<void> deletePolicy(id, int index, String searchQuery) {
    return policies.doc(id).delete().then((value) {
      widget.policyList.removeAt(index);
      setState(() {
        filterResult = widget.policyList
            .where((onepolicy) => onepolicy['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
        if (filterResult.isEmpty) {
          searchedPolicy = const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 50),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "No Policies, Go add them...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        } else {
          searchedPolicy = SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
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
                              Text(filterResult[index]['name']),
                              const Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Text(filterResult[index]['policy_number']),
                              const Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Date of next renewal: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat('MMM d, y')
                                      .format(
                                          filterResult[index]['dnr'].toDate())
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
                                            id: filterResult[index]['id']),
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
                                    deletePolicy(filterResult[index]['id'],
                                        index, query);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              },
              childCount: filterResult.length,
            ),
          );
        }
      });
    }).catchError((error) {
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

  searchPolicy(String stringToBeSearched) {
    setState(() {
      filterResult = widget.policyList
          .where((onepolicy) => onepolicy['name']
              .toLowerCase()
              .contains(stringToBeSearched.toLowerCase()))
          .toList();

      if (filterResult.isEmpty) {
        searchedPolicy = const SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 50),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                "No Policies, Go add them...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      } else {
        searchedPolicy = SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10),
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
                            Text(filterResult[index]['name']),
                            const Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text(filterResult[index]['policy_number']),
                            const Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Date of next renewal: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(DateFormat('MMM d, y')
                                    .format(filterResult[index]['dnr'].toDate())
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
                                          id: filterResult[index]['id']),
                                    ),
                                  );
                                },
                                child: const Text("View"),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3)),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  deletePolicy(
                                      filterResult[index]['id'], index, query);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
            childCount: filterResult.length,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Search your policies..."),
        ),
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                ),
                TextField(
                  onChanged: (value) {
                    query = value;
                    searchPolicy(value);
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    labelText: "Search by  Name",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ],
            ),
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            automaticallyImplyLeading: false,
          ),
          searchedPolicy,
        ],
      ),
    );
  }
}
