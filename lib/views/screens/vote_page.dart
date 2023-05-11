import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controllers/helper/firestore_helper.dart';

class Vote_Page extends StatefulWidget {
  const Vote_Page({Key? key}) : super(key: key);

  @override
  State<Vote_Page> createState() => _Vote_PageState();
}

class _Vote_PageState extends State<Vote_Page> {
  String selectParty = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vote"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.fetchVote(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("Error : ${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            if (data == null) {
              return const Center(
                child: Text("No Any Data Available...."),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return Column(
                children: [
                  ListTile(
                    leading: Radio<String>(
                      value: 'BJP',
                      groupValue: selectParty,
                      onChanged: (value) {
                        setState(() {
                          selectParty = value!;
                        });
                      },
                    ),
                    title: const Text('BHARTIYA JANTA PARTY'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'AAP',
                      groupValue: selectParty,
                      onChanged: (value) {
                        setState(() {
                          selectParty = value!;
                        });
                      },
                    ),
                    title: const Text('AAM AADMI PARTY'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'CON',
                      groupValue: selectParty,
                      onChanged: (value) {
                        setState(() {
                          selectParty = value!;
                        });
                      },
                    ),
                    title: const Text('Congress'),
                  ),
                  ListTile(
                    leading: Radio<String>(
                      value: 'Other',
                      groupValue: selectParty,
                      onChanged: (value) {
                        setState(() {
                          selectParty = value!;
                        });
                      },
                    ),
                    title: const Text('Other'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: GestureDetector(
                      onTap: () async {
                        if (selectParty == 'BJP') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You Vote BJP"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          int count = allDocs[1].data()['vote'];

                          Map<String, dynamic> records = {
                            "vote": count + 1,
                            "party": "BJP",
                          };

                          await FirestoreHelper.firestoreHelper
                              .updateData(data: records, Party: allDocs[1].id);
                        } else if (selectParty == 'AAP') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You Vote AAP"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          int count = allDocs[0].data()['vote'];

                          Map<String, dynamic> records = {
                            "vote": count + 1,
                            "party": "AAP",
                          };

                          await FirestoreHelper.firestoreHelper
                              .updateData(data: records, Party: allDocs[0].id);
                        } else if (selectParty == 'CON') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You Vote CON"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          int count = allDocs[2].data()['vote'];

                          Map<String, dynamic> records = {
                            "vote": count + 1,
                            "party": "CON",
                          };

                          await FirestoreHelper.firestoreHelper
                              .updateData(data: records, Party: allDocs[2].id);
                        } else if (selectParty == 'Other') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You Vote Other"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          int count = allDocs[3].data()['vote'];

                          Map<String, dynamic> records = {
                            "vote": count + 1,
                            "party": "Other",
                          };

                          await FirestoreHelper.firestoreHelper
                              .updateData(data: records, Party: allDocs[3].id);
                        }

                        Navigator.pushNamedAndRemoveUntil(
                            context, 'party_page', (route) => false);
                      },
                      child: Container(
                        height: 70,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.teal,
                        ),
                        child: const Text(
                          "VOTE",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
