import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class AddPolicy extends StatefulWidget {
  const AddPolicy({super.key});
  @override
  AddPolicyState createState() {
    return AddPolicyState();
  }
}

class AddPolicyState extends State<AddPolicy> {
  final _formkey = GlobalKey<FormState>();

  CollectionReference policies =
      FirebaseFirestore.instance.collection("policies");

  Future<void> addPolicy(
      BuildContext context,
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
      dnr) async {
    QuerySnapshot snapshot =
        await policies.where('policy_number', isEqualTo: policyNumber).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.reference.set(
        {
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
        },
        SetOptions(merge: true),
      ).then((value) {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Policy added"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _formkey.currentState?.reset();
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
                      _formkey.currentState?.reset();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            });
      });
    }

    return policies.add({
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
      'createdAt': DateTime.now(),
    }).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Policy added"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _formkey.currentState?.reset();
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
                    _formkey.currentState?.reset();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    });
  }

  var name = "";
  var nominee = "";
  var policyNumber = "";
  var planName = "";
  var tableAndTerm = "";
  var sumAssured = "";
  var mode = "";
  var dob = DateTime.now();
  var dom = DateTime.now();
  var doc = DateTime.now();
  var dlp = DateTime.now();
  var dnr = DateTime.now();
  var dlap = DateTime.now();

  void calculateDNR(doc, dlp, selectedmode) {
    if (selectedmode == "yearly") {
      // if (dlp.month >= doc.month) {
      //   if (dlp.year < DateTime.now().year) {
      //     dnr = DateTime(dlp.year + 1, doc.month, doc.day);
      //     return;
      //   }
      // }
      dnr = DateTime(dlp.year + 1, doc.month, doc.day);
      return;
    }
    if (selectedmode == "half-yearly") {
      if ((dlp.month + 6) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 6) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 6), doc.day);
      }
      return;
    }
    if (selectedmode == "quaterly") {
      if ((dlp.month + 3) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 3) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 3), doc.day);
      }
      return;
    }
    if (selectedmode == "monthly") {
      if ((dlp.month + 1) > 12) {
        dnr = DateTime(dlp.year + 1, (dlp.month + 1) % 12, doc.day);
      } else {
        dnr = DateTime(dlp.year, (dlp.month + 1), doc.day);
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedmode = "yearly";
    var modes = [
      "yearly",
      "half-yearly",
      "quaterly",
      "monthly",
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Add your Policies here..."),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: TextFormField(
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
                  onDateSelected: (DateTime value) {
                    dob = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter DOB",
                    labelText: "Date of Birth:",
                  ),
                  lastDate: DateTime.now(),
                  mode: DateTimeFieldPickerMode.date,
                  validator: (value) {
                    if (value == null) {
                      return "Enter Date of Birth";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: DateTimeFormField(
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
                  onDateSelected: (DateTime value) {
                    dlap = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter date of Last Premium",
                    labelText: "Date of Last Premium:",
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  validator: (value) {
                    if (value == null) {
                      return "Enter Date of last premium";
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
                    // value: mode,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: modes.map((String modess) {
                      return DropdownMenuItem(
                        value: modess,
                        child: Text(modess),
                      );
                    }).toList(),
                    onChanged: (String? newmode) {
                      selectedmode = newmode!;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: TextFormField(
                  // controller: assured_controller,
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
                  onDateSelected: (DateTime value) {
                    doc = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter DOC",
                    labelText: "Date of Commencement/Start:",
                  ),
                  // firstDate: DateTime(2020, 3, 8),
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
                        if (!(_formkey.currentState!.validate())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Fill all the fields.")));
                        } else {
                          calculateDNR(doc, dlp, selectedmode);
                          mode = selectedmode;
                          addPolicy(
                              context,
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
                        "Submit",
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
                        _formkey.currentState?.reset();
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
  }
}
