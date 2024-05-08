import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_do/model/user_dm.dart';
import 'package:to_do/screens/home_screen.dart';

import '../app_colors.dart';
import '../controller/settings_provider.dart';
import '../firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  String _errorMessage = '';

  void _toggleAuthMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _errorMessage = '';
      _emailController.clear();
      _passwordController.clear();
      _userNameController.clear();
    });
  }

  Future<void> _submitForm() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    String userName =_userNameController.text;


    if (_formKey.currentState!.validate()) {
      try {
        if (_isSignUp) {
          // Sign up
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          // Handle successful sign up
          UserDm userDm = UserDm(id: userCredential.user!.uid, userName: userName, email: email);
          await registerUserInFirestore(userDm);
          print('Signed up: ${userCredential.user!.email}');
        } else {
          // Log in
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          await getUserFromFirestore(userCredential.user!.uid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyAppHome(),));
          // Handle successful log in
          print('Logged in: ${userCredential.user!.email}');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message!;
          print("Erorr@%#%%&%#%@#%^ ${_errorMessage}");
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context);
    return Scaffold(
      backgroundColor:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkPrimaryColor: const Color(0xfffdfecdb),
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _isSignUp==true? TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid name';
                  }
                  return null;
                },
              ): Text("WELCOME BACK ${_userNameController.text}!",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.green
              ),
              ),
              TextFormField(
                cursorColor: settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.white,
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                  labelStyle: TextStyle(
                    color:settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.grey,
                  )
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password',
                    labelStyle: TextStyle(
                      color:settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.grey,
                    )
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isSignUp ? 'Sign Up' : 'Log In'),
              ),
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(
                  _isSignUp ? 'Already have an account? Log In' : 'Create a new account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
