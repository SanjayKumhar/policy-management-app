import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policy_management_app/edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //for formatting date

import 'view_dates.dart';

class ViewPolicy extends StatefulWidget {
  final String id;
  const ViewPolicy({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewPolicy> createState() => ViewPolicyState();
}

class ViewPolicyState extends State<ViewPolicy> {
  // const ViewPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> policiesStream = FirebaseFirestore.instance
        .collection('policies')
        .doc(widget.id)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: policiesStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!(snapshot.hasData)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Center(child: Text("Policy Details...")),
            ),
            body: const Center(
              child: Text(
                "Error: Close the app and try again...",
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
        var policiesdocs = snapshot.data!;

        if (!(policiesdocs.exists)) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Center(child: Text("Policy Details...")),
            ),
            body: const Center(
              child: Text(
                "Sorry, Close App and...TRY AGAIN...",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Center(child: Text("Policy Details...")),
          ),
          body: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                "Name: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['name']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                          ),
                          Wrap(
                            children: <Widget>[
                              const Text(
                                "Nominee: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['nominee']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Policy No.: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['policy_number'].toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Plan name: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['plan_name']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Table and term: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['table_and_term']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Date of birth: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(policiesdocs['dob'].toDate())
                                  .toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Date of Start of policy: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(policiesdocs['doc'].toDate())
                                  .toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Date of Last premium: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(policiesdocs['dlap'].toDate())
                                  .toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Date of Maturity: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(policiesdocs['dom'].toDate())
                                  .toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Mode of Payment: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['mode']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Sum assured: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(policiesdocs['sum_assured']),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                "Date of next Renewal: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat('MMM d, y')
                                  .format(policiesdocs['dnr'].toDate())
                                  .toString()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditPolicy(id: widget.id)),
                                  );
                                },
                                child: const Text("Edit"),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewDates(id: widget.id)),
                                  );
                                },
                                child: const Text("All Premium Dates"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
