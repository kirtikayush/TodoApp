import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../LoginIn.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isTapped = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isTapped = true;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _isTapped = false;
      });
    });
  }
  /*
  bool passwordConfirmation() {
    if (_passwordController == _confirmPasswordController) {
      return true;
    } else {
      return false;
    }
  }

   */

  Future signUserUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
            strokeWidth: 3,
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      addUserDetails(_nameController.text.trim(), _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Signup successful! Login now!'),
          backgroundColor: Colors.green,
        ),
      );

      //?Navigator.pop(context); // Go back to login or home
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginIn()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already in use.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'weak-password':
          message = 'Password must be at least 6 characters.';
          break;
        default:
          message = 'Signup failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future addUserDetails(String name, String email) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff323232),
              Color(0xff252525),
              Color(0xff1a1a1a),
              Color(0xff121212),
              Color(0xff000000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.5, 0.65, 0.8, 0.9, 1],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 45,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  CupertinoIcons.back,
                  size: 35,
                  color: CupertinoColors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //*Name
                        buildLabel('Name'),
                        buildTextField(
                          controller: _nameController,
                          hint: 'Enter your name',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        //*Email
                        buildLabel('Email'),
                        buildTextField(
                          controller: _emailController,
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter your email';
                            final emailRegex = RegExp(r'\S+@\S+\.\S+');
                            if (!emailRegex.hasMatch(value))
                              return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        //*Password
                        buildLabel('Password'),
                        buildTextField(
                          controller: _passwordController,
                          hint: 'Enter your password',
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter a password';
                            if (value.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        //*ConfirmPassword
                        buildLabel('Confirm Password'),
                        buildTextField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm your password',
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please confirm password';
                            if (value != _passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        //*SignUp
                        Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap:
                                  _isLoading
                                      ? null
                                      : () {
                                        _handleTap();
                                        signUserUp();
                                      },
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.white24,
                              highlightColor: Colors.white10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      _isTapped
                                          ? Colors.red.withOpacity(0.4)
                                          : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        _isTapped ? Colors.black : Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Sign Up",
                                      style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white70,
                                        fontSize: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      CupertinoIcons.arrow_right_square,
                                      color: Colors.white70,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 30),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white10,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
