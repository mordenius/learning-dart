import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _pswd;

  @override
  void initState() {
    _email = TextEditingController();
    _pswd = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pswd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text("Loading...");
            case ConnectionState.done:
              return Center(
                  child: Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: "Enter your email"),
                  ),
                  TextField(
                    controller: _pswd,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: "Enter your peassword"),
                  ),
                  TextButton(
                    child: const Text("Register"),
                    onPressed: () async {
                      final email = _email.text;
                      final pswd = _pswd.text;
                      try {
                        final userCredentials = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: pswd);
                        print(userCredentials);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "weak-password") {
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        'Use more complexity password'),
                                    content: Text('${e.message}'),
                                  ));
                        }

                        if (e.code == "email-already-in-use") {
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text('Email already in use'),
                                    content: Text('${e.message}'),
                                  ));
                        }

                        if (e.code == "invalid-email") {
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text('Email is invalid'),
                                    content: Text('${e.message}'),
                                  ));
                        }

                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title:
                                      const Text(' Ops! Registration Failed'),
                                  content: Text('${e.message}'),
                                ));
                      } catch (error) {
                        print('Something went wrong');
                        print(error);
                      }
                    },
                    style: const ButtonStyle(backgroundColor: null),
                  )
                ],
              ));
            default:
              return const Text("Something went wrong");
          }
        },
      ),
    );
  }
}
