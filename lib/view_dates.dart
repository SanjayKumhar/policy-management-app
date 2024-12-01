import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDates extends StatefulWidget {
  final String id;
  const ViewDates({super.key, required this.id});

  @override
  State<ViewDates> createState() => ViewDatesState();
}

class ViewDatesState extends State<ViewDates> {
  final _datesformkey = GlobalKey<FormFieldState>();

  CollectionReference policies =
      FirebaseFirestore.instance.collection('policies');

  Future<void> addDates(BuildContext context, id, alldate) async {
    return policies.doc(id).update({
      // add new date to existing dates by array union
      "all_dates": FieldValue.arrayUnion([alldate]),
    }).then((value) {
      _datesformkey.currentState?.reset();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Date added successfully.",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
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

  Future<void> editDate(BuildContext context, id, editdate, policiesdocs, i) {
    List<dynamic> dateList = policiesdocs['all_dates'];
    dateList[i] = editdate;
    return policies.doc(id).update({
      "all_dates": dateList,
    }).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
        content: Text(
          "Date edited successfully.",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      showDialog<void>(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ERROR occured:"),
              content: Text("Close app and try again: $error"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(this.context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    });
  }

  Future<void> deleteDate(BuildContext context, id, alldate) {
    return policies.doc(id).update({
      "all_dates": FieldValue.arrayRemove([alldate]),
    }).then((value) {
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
        content: Text(
          "Date deleted successfully.",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      showDialog<void>(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ERROR occured:"),
              content: Text("Close app and try again: $error"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(this.context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    });
  }

  var allDates = DateTime.now();

  Widget addedDatesList = const Center(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        "* No previous premium dates, have been added *",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );

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
                title: const Center(child: Text("Previous Payment Dates")),
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
                title: const Center(child: Text("Previous Payment Dates")),
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

          if (policiesdocs.data().toString().contains('all_dates')) {
            if (policiesdocs['all_dates'].length != 0) {
              List<dynamic> dateList = policiesdocs['all_dates'];
              dateList.sort();
              addedDatesList = Expanded(
                child: ListView.builder(
                  itemCount: policiesdocs['all_dates'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(DateFormat('MMM dd, y')
                                  .format(
                                      policiesdocs['all_dates'][index].toDate())
                                  .toString()),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green[900]),
                              onPressed: () {
                                BuildContext parentContext = context;
                                var editedDate =
                                    policiesdocs['all_dates'][index].toDate();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Edit date below:"),
                                        content: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Form(
                                            child: DateTimeFormField(
                                              initialValue:
                                                  (policiesdocs['all_dates']
                                                          [index]
                                                      .toDate()),
                                              onDateSelected:
                                                  (DateTime value) =>
                                                      editedDate = value,
                                              mode:
                                                  DateTimeFieldPickerMode.date,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(3),
                                                  labelText:
                                                      "Paid Premium Date:"),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(this.context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              editDate(
                                                  parentContext,
                                                  widget.id,
                                                  editedDate,
                                                  policiesdocs,
                                                  index);
                                            },
                                            child: const Text("Submit"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      width: 1,
                                    )),
                                child:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                              onTap: () {
                                BuildContext parentContext = context;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm Delete ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(this.context);
                                              },
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                deleteDate(
                                                    parentContext,
                                                    widget.id,
                                                    policiesdocs['all_dates']
                                                        [index]);
                                                Navigator.pop(this.context);
                                              },
                                              child: const Text("OK")),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                        tileColor: Colors.green[300],
                      ),
                    );
                  },
                ),
              );
            } else {
              addedDatesList = const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "* No previous premium dates, have been added *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text("Previous Premium Dates..."),
              ),
              automaticallyImplyLeading: true,
            ),
            body: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DateTimeFormField(
                      key: _datesformkey,
                      mode: DateTimeFieldPickerMode.date,
                      onDateSelected: (value) {
                        allDates = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Previous premium date",
                        suffixIcon: IconButton(
                          onPressed: () {
                            BuildContext parentContext = context;
                            if (!(_datesformkey.currentState!.validate())) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Fill date"),
                                duration: Duration(seconds: 1),
                              ));
                            } else {
                              addDates(parentContext, widget.id, allDates);
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Enter paid premium date";
                        }
                        return null;
                      },
                    ),
                  ),
                  addedDatesList,
                ],
              ),
            ),
          );
        });
  }
}
