import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';
import 'registration_screen.dart';

class AuthLoginScreen extends StatelessWidget {
  AuthLoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ''.obs;
    var password = ''.obs;
    var passwordVisibility = false.obs;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(height: size.height * 0.05),
                  InputWidget(
                    controller: emailController,
                    hintText: 'Email Address',
                    label: true,
                    keyBoardType: TextInputType.emailAddress,
                    onChanged: (value) => email.value = value,
                    validator: (value) =>
                        value == null || !GetUtils.isEmail(value)
                            ? 'Enter a valid email address'
                            : null,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Obx(
                    () => InputWidget(
                      controller: passwordController,
                      hintText: 'Password',
                      label: true,
                      obscureText: passwordVisibility.isFalse ? true : false,
                      suffix: GestureDetector(
                        onTap: () {
                          passwordVisibility.value = !passwordVisibility.value;
                        },
                        child: Icon(
                          passwordVisibility.isFalse
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: (value) => password.value = value,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Password should be at least 6 characters'
                          : null,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  primaryButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AuthHomeScreen(),
                                ),
                              );
                            } else {
                              Get.snackbar('Error', 'Invalid Credentials',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                          });
                        }
                      },
                      text: 'Login'),
                  SizedBox(height: size.height * 0.04),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => AuthRegistrationScreen()));
                      },
                      child:
                          const Text('Don\'t have an account? Register here.')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      return user;
    } on FirebaseAuthException catch (error) {
      debugPrint(error.code);
      debugPrint(error.message);
      debugPrint(error.stackTrace.toString());
      return null;
    }
  }
}
