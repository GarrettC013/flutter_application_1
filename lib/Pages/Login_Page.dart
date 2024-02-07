import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Pages/SignUp_page.dart';

// class MyLoginApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LoginPage(),
//         '/signup': (context) => SignupPage(),
//       },
//     );
//   }
// }

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      debugPrint("email: ${email} password: ${password}");
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      print("Error during login: $e");
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error during login: ${e.message}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: emailController,
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              controller: passwordController,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                debugPrint("LoginPage email: $email password: $password");
                signIn(email, password, context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/signup');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
