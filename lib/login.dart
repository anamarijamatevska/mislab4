import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'registration.dart';
import './main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 35.0,
              ),
              const SizedBox(
                height: 1.0,
              ),
              const Text(
                "Login",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        textStyle: const TextStyle(
                          color: Colors.white
                        ),
                        shape: const StadiumBorder()
                      ),
                      child: Container(
                        height: 50.0,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage("Email address is not Valid.", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage("Password is mandatory.", context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                },
                child: const Text("Do not have an Account? Register Here."),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: $errMsg", context);
    }))
        .user;

    if (firebaseUser != null) {
      //save user info to database

      DataSnapshot snap;
      usersRef.child(firebaseUser.uid).once().then((snap) {
        if (snap.snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are logged in.", context);
        } else {
          Navigator.pop(context);

          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this user. Please create a new account.", context);
        }
      });
    } else {
      Navigator.pop(context);

      //error occured - display error msg
      displayToastMessage("Error occured, cannot be signed in.", context);
    }
  }
}
