import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class EditPolicy extends StatefulWidget {
  final String id;
  const EditPolicy({super.key, required this.id});
  @override
  State<EditPolicy> createState() => EditPolicyState();
}

class EditPolicyState extends State<EditPolicy> {
  final _editformkey = GlobalKey<FormState>();

  CollectionReference policies =
      FirebaseFirestore.instance.collection('policies');

  Future<void> updatePolicy(
      BuildContext context,
      id,
      name,
      nominee,
      policyNumber,
      planName,
      tableAndTerm,
      sumAssured,
      mode,
      dob,
      doc,
      dlp,
      dom,
      dlap,
      dnr) {
    return policies.doc(id).update({
      'name': name,
      'nominee': nominee,
      'policy_number': policyNumber,
      'plan_name': planName,
      'table_and_term': tableAndTerm,
      'sum_assured': sumAssured,
      'mode': mode,
      'dob': dob,
      'doc': doc,
      'dlp': dlp,
      'dom': dom,
      'dlap': dlap,
      'dnr': dnr,
    }).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Policy updated"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
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

  DateTime calculateDNR(dnr, doc, dlp, selectedmode) {
    if (selectedmode == "yearly") {
      dnr = DateTime(dlp.year + 1, doc.month, doc.day);
      return dnr;
    }
    if (selectedmode == "half-yearly") {
      if ((dlp.month + 6) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 6) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 6), doc.day);
      }
      return dnr;
    }
    if (selectedmode == "quaterly") {
      if ((dlp.month + 3) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 3) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 3), doc.day);
      }
      return dnr;
    }
    if (selectedmode == "monthly") {
      if ((dlp.month + 1) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 1) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 1), doc.day);
        return dnr;
      }
    }
    return dnr;
  }

  @override
  Widget build(BuildContext context) {
    var modes = [
      "yearly",
      "half-yearly",
      "quaterly",
      "monthly",
    ];

    // final Stream<DocumentSnapshot> policiesStream = FirebaseFirestore.instance
    //     .collection('policies')
    //     .doc(widget.id)
    //     .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('policies')
            .doc(widget.id)
            .snapshots(),
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
                title: const Center(child: Text("Edit your policy here...")),
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
                title: const Center(child: Text("Edit your policy here...")),
              ),
              body: const Center(
                child: Text(
                  "Sorry, failed to edit...TRY AGAIN...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
              ),
            );
          }

          String selectMode = policiesdocs['mode'];
          var name = policiesdocs['name'];
          var nominee = policiesdocs['nominee'];
          var policyNumber = policiesdocs['policy_number'];
          var planName = policiesdocs['plan_name'];
          var tableAndTerm = policiesdocs['table_and_term'];
          var sumAssured = policiesdocs['sum_assured'];
          var mode = "";
          var dob = policiesdocs['dob'].toDate();
          var dom = policiesdocs['dom'].toDate();
          var dlap = policiesdocs['dlap'].toDate();
          var doc = policiesdocs['doc'].toDate();
          var dlp = policiesdocs['dlp'].toDate();
          var dnr = policiesdocs['dnr'].toDate();

          return Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text("Edit your Policy here..."),
              ),
            ),
            body: Form(
              key: _editformkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['name'],
                        onChanged: (value) => name = value,
                        decoration: const InputDecoration(
                          hintText: "Name",
                          labelText: "Name:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['nominee'],
                        onChanged: (value) => nominee = value,
                        decoration: const InputDecoration(
                          hintText: "Nominee",
                          labelText: "Nominee Name:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter nominee name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['policy_number'],
                        onChanged: (value) => policyNumber = value,
                        decoration: const InputDecoration(
                          hintText: "Policy number",
                          labelText: "Policy No.:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter policy number";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['plan_name'],
                        onChanged: (value) => planName = value,
                        decoration: const InputDecoration(
                          hintText: "Plan name",
                          labelText: "Plan name:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter plan name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['table_and_term'],
                        onChanged: (value) => tableAndTerm = value,
                        decoration: const InputDecoration(
                          hintText: "Policy Term",
                          labelText: "Policy Term:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter policy term";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DateTimeFormField(
                        initialValue: policiesdocs['dob'].toDate(),
                        onDateSelected: (DateTime value) {
                          dob = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter DOB",
                          labelText: "Date of Birth:",
                        ),
                        // firstDate: DateTime(2020, 3, 8),
                        lastDate: DateTime.now(),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return "Enter Date of Birth";
                          }
                          return null;
                        },
                        // selectedDate: date,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DateTimeFormField(
                        initialValue: policiesdocs['dlp'].toDate(),
                        onDateSelected: (DateTime value) {
                          dlp = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter date of latest premium",
                          labelText: "Date of latest premium:",
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return "Enter Date of latest premium";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DateTimeFormField(
                        initialValue: policiesdocs['dom'].toDate(),
                        onDateSelected: (DateTime value) {
                          dom = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter date of maturity",
                          labelText: "Date of maturity:",
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return "Enter Date of maturity";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DateTimeFormField(
                        initialValue: policiesdocs['dlap'].toDate(),
                        onDateSelected: (DateTime value) {
                          dlap = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter date of Last premium",
                          labelText: "Date of Last Premium:",
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return "Enter Date of Last Premium";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Payment Mode:",
                          ),
                          value: selectMode,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: modes.map((String modess) {
                            return DropdownMenuItem(
                              value: modess,
                              child: Text(modess),
                            );
                          }).toList(),
                          onChanged: (String? newmode) {
                            selectMode = newmode!;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: TextFormField(
                        initialValue: policiesdocs['sum_assured'],
                        onChanged: (value) => sumAssured = value,
                        decoration: const InputDecoration(
                          hintText: "Sum assured",
                          labelText: "Sum assured:",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter sum assured";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      child: DateTimeFormField(
                        initialValue: policiesdocs['doc'].toDate(),
                        onDateSelected: (DateTime value) {
                          doc = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter DOC",
                          labelText: "Date of Commencement/Start:",
                        ),
                        lastDate: DateTime.now(),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return "Enter Date of previous renewal";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () {
                              if (!(_editformkey.currentState!.validate())) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Fill all the fields.")));
                              } else {
                                dnr = calculateDNR(dnr, doc, dlp, selectMode);
                                mode = selectMode;
                                updatePolicy(
                                    context,
                                    widget.id,
                                    name,
                                    nominee,
                                    policyNumber,
                                    planName,
                                    tableAndTerm,
                                    sumAssured,
                                    mode,
                                    dob,
                                    doc,
                                    dlp,
                                    dom,
                                    dlap,
                                    dnr);
                              }
                            },
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () {
                              _editformkey.currentState?.reset();
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
