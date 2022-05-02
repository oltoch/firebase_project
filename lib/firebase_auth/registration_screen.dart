import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom_widgets.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthRegistrationScreen extends StatelessWidget {
  AuthRegistrationScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var firstName = ''.obs;
    var lastName = ''.obs;
    var email = ''.obs;
    var password = ''.obs;
    var phone = ''.obs;
    var passwordVisibility = false.obs;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                    SizedBox(height: size.height * 0.05),
                    InputWidget(
                      controller: firstNameController,
                      hintText: 'First Name',
                      label: true,
                      onChanged: (value) => firstName.value = value,
                      validator: (value) => (value == null || value.length < 3)
                          ? 'First Name should be at least 3 characters'
                          : null,
                    ),
                    SizedBox(height: size.height * 0.02),
                    InputWidget(
                      controller: lastNameController,
                      hintText: 'Last Name',
                      label: true,
                      onChanged: (value) => lastName.value = value,
                      validator: (value) => (value == null || value.length < 3)
                          ? 'Last Name should be at least 3 characters'
                          : null,
                    ),
                    SizedBox(height: size.height * 0.02),
                    InputWidget(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      label: true,
                      keyBoardType: TextInputType.phone,
                      onChanged: (value) => phone.value = value,
                      validator: (value) =>
                          (value == null || value.length != 11)
                              ? 'Enter a valid phone number'
                              : null,
                    ),
                    SizedBox(height: size.height * 0.02),
                    InputWidget(
                      controller: emailController,
                      hintText: 'Email',
                      label: true,
                      keyBoardType: TextInputType.emailAddress,
                      onChanged: (value) => email.value = value,
                      validator: (value) =>
                          value == null || !GetUtils.isEmail(value)
                              ? 'Enter a valid email address'
                              : null,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Obx(
                      () => InputWidget(
                        controller: passwordController,
                        hintText: 'Password',
                        label: true,
                        obscureText: passwordVisibility.isFalse ? true : false,
                        suffix: GestureDetector(
                          onTap: () {
                            passwordVisibility.value =
                                !passwordVisibility.value;
                          },
                          child: Icon(
                            passwordVisibility.isFalse
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        onChanged: (value) => password.value = value,
                        validator: (value) =>
                            (value == null || value.length < 6)
                                ? 'Password should be at least 6 characters'
                                : null,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    primaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser(emailController.text,
                                    passwordController.text)
                                .then((value) {
                              if (value != null) {
                                uploadUserData(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phone: phoneController.text);

                                Get.snackbar(
                                    'Success', 'Registration Successful',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2));
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AuthHomeScreen(),
                                  ),
                                );
                              } else {
                                Get.snackbar('Error', 'Account not created',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2));
                              }
                            });
                          }
                        },
                        text: 'Register'),
                    SizedBox(height: size.height * 0.04),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => AuthLoginScreen()));
                        },
                        child:
                            const Text('Already have an account? Login here.')),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      return user;
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      debugPrint(error.stackTrace.toString());
      return null;
    }
  }

  void uploadUserData({
    required String firstName,
    required String lastName,
    required String phone,
  }) {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': user.email
      }).then((value) {
        debugPrint('User data uploaded');
      }).catchError((error) {
        debugPrint(error);
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
