import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/firebase_storage/storage_screen.dart';
import 'package:firebase_project/firestore_crud/crud_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHomeScreen extends StatefulWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  State<AuthHomeScreen> createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  var firstName = ''.obs,
      lastName = ''.obs,
      email = ''.obs,
      phoneNumber = ''.obs;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      firstName.value = value.data()!['firstName'];
      lastName.value = value.data()!['lastName'];
      email.value = value.data()!['email'];
      phoneNumber.value = value.data()!['phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome $firstName $lastName'),
            SizedBox(height: size.height * 0.03),
            Text('Email: $email'),
            SizedBox(height: size.height * 0.03),
            Text('Phone: $phoneNumber'),
            SizedBox(height: size.height * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: const Text('Logout'),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CRUDScreen()));
                },
                child: const Text('Goto CRUD'),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const StorageScreen()));
                },
                child: const Text('Goto Storage'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.of(context).pop());
  }
}
