import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controllers/helper/firestore_helper.dart';

class Party_Page extends StatefulWidget {
  const Party_Page({Key? key}) : super(key: key);

  @override
  State<Party_Page> createState() => _Party_PageState();
}

class _Party_PageState extends State<Party_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Party Vote"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder(
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
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allDocs = data.docs;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: allDocs.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                leading: Text("${allDocs[i].id}"),
                                title: Text("${allDocs[i].data()['party']}"),
                                trailing: Text("${allDocs[i].data()['vote']}"),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
