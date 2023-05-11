import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controllers/helper/firestore_helper.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController panController = TextEditingController();

  String? name;
  String? pan;
  int? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Vote App",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 5,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.checkUser(),
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

              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Your Name First...";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          name = val;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: phoneController,
                          validator: (val) {
                            if (val!.length != 10) {
                              return "Enter Valid Phone Number";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            phone = int.parse(val!);
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            labelText: "Phone No",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: panController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter Your Pan Card No First...";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            pan = val;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "Enter Pan Number",
                            labelText: "Pan No",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              bool user = false;

                              for (int i = 0; i < allDocs.length; i++) {
                                if (allDocs[i].data()['pan'] == pan) {
                                  user = true;
                                }
                              }

                              if (user == false) {
                                Map<String, dynamic> records = {
                                  "name": name,
                                  "phone": phone,
                                  "pan": pan,
                                };

                                await FirestoreHelper.firestoreHelper
                                    .insertRecords(data: records);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You Can Vote"),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                nameController.clear();
                                phoneController.clear();
                                panController.clear();

                                setState(() {
                                  name = null;
                                  phone = null;
                                  pan = null;
                                });

                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'vote_page', (route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Already Voted......!!\nYou are not able to vote"),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 65,
                            width: 170,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.teal,
                            ),
                            child: const Text(
                              "DONE",
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
                  ),
                ),
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
