import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Column(
      children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: "Enter your email"),
        ),
        TextField(
          controller: _pswd,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: "Enter your peassword"),
        ),
        TextButton(
          child: const Text("Login"),
          onPressed: () async {
            final email = _email.text;
            final pswd = _pswd.text;
            try {
              final userCredentials = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: pswd);
              print(userCredentials);
            } on FirebaseAuthException catch (e) {
              if (e.code == "user-not-found") {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('User not found'),
                          content: Text('${e.message}'),
                        ));
              }

              if (e.code == "wrong-password") {
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Check your credentials'),
                          content: Text('${e.message}'),
                        ));
              }

              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text(' Ops! Registration Failed'),
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
    );
  }
}
