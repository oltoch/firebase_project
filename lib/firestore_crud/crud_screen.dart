import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_widgets.dart';

class CRUDScreen extends StatefulWidget {
  const CRUDScreen({Key? key}) : super(key: key);

  @override
  State<CRUDScreen> createState() => _CRUDScreenState();
}

class _CRUDScreenState extends State<CRUDScreen> {
  List<Map<String, dynamic>> data = [];
  List<String> keys = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text('Name: ${data[index]['name']}'),
                    subtitle: Text('Job Title: ${data[index]['title']}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 20),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  showBottomSheet(context,
                                      update: true, id: keys[index]);
                                },
                                child: Text('Edit')),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  deleteData(keys[index]);
                                },
                                child: Text('Delete')),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
          const SizedBox(height: 20),
          primaryButton(
            onPressed: () {
              showBottomSheet(context);
            },
            child: const Text('Add new'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context,
      {bool update = false, String? id}) {
    String name = '';
    String job = '';
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  InputWidget(
                    hintText: 'Name',
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  InputWidget(
                    hintText: 'Job',
                    onChanged: (value) {
                      setState(() {
                        job = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  primaryButton(
                    onPressed: () {
                      if (update) {
                        updateData(id!, name, job);
                      } else {
                        addData(name, job);
                      }
                    },
                    child: Text(update ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addData(String name, String job) async {
    Map<String, dynamic> map = {'name': name.trim(), 'title': job.trim()};
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('data');
    await collectionReference.add(map).then((value) {
      Get.snackbar('Success', 'Data added successfully');
      Navigator.of(context).pop();
    });
  }

  void fetchData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('data');
    await for (var snapshot in collectionReference.snapshots()) {
      data.clear();
      for (var message in snapshot.docs) {
        Map<String, dynamic> map = message.data() as Map<String, dynamic>;
        setState(() {
          data.add({'name': map['name'], 'title': map['title']});
          keys.add(message.id);
        });
      }
    }
  }

  void updateData(String id, String name, String job) async {
    Map<String, dynamic> map = {'name': name, 'title': job};
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs
        .firstWhere((element) => element.id == id)
        .reference
        .update(map)
        .then((value) {
      Get.snackbar('Success', 'Data updated successfully');
      Navigator.of(context).pop();
    });
  }

  void deleteData(String id) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs
        .firstWhere((element) => element.id == id)
        .reference
        .delete()
        .then((value) {
      Get.snackbar('Success', 'Data added successfully');
    });
  }
}
