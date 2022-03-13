import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './views/register_view.dart';
import './views/login_view.dart';
import './firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final emailVerified =
                    FirebaseAuth.instance.currentUser?.emailVerified ?? false;
                if (emailVerified) {
                  print('Email verified');
                } else {
                  print('You need to verify your email first');
                }

                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Hello"),
                  ),
                  body: const LoginView(),
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }
}
