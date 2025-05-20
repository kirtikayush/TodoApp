import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/authentication/signup.dart';

import 'ToDo_page.dart';

class LoginIn extends StatefulWidget {
  LoginIn({super.key});

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {
  bool _isTappedLogin = false;
  bool _isTappedSignup = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TodoPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message;

      if (e.code == 'user-not-found') {
        message = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'Login failed. Please check your credentials.';
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

  void _handleTapLogin() {
    setState(() {
      _isTappedLogin = true;
    });

    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        _isTappedLogin = false;
      });
    });
  }

  void _handleTapSignup() {
    setState(() {
      _isTappedSignup = true;
    });

    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        _isTappedSignup = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff323232),
              Color(0xff252525),
              Color(0xff1a1a1a),
              Color(0xff121212),
              Color(0xff000000),
            ],
            stops: [0.5, 0.65, 0.8, 0.9, 1],
          ),
        ),
        child: Center(
          child: Container(
            //height: 300,
            width: 300,
            //color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //*Login heading
                  Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //*Name
                  Text(
                    'Email',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 8),

                  //*Name field
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //*Password
                  Text(
                    'Password',
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 8),

                  //*Password Field
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  //*Login button
                  Center(
                    child: Material(
                      color: Colors.transparent, // Keep background transparent
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () {
                          print('Login tapped');
                          _handleTapLogin();
                          signUserIn();
                        },
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Matches container
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                _isTappedLogin
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.transparent,
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(CupertinoIcons.lock, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //*Line separator
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.red,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                      Text(
                        'OR',
                        style: GoogleFonts.spaceGrotesk(
                          textStyle: TextStyle(
                            color: Colors.white60,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.red,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  //*SignUp button
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          _handleTapSignup();
                          Future.delayed(Duration(milliseconds: 50), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                            bottom: 15,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _isTappedSignup
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.white70.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color:
                                  _isTappedSignup ? Colors.black : Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      _isTappedSignup
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.arrow_right_square,
                                color:
                                    _isTappedSignup
                                        ? Colors.white
                                        : Colors.black,
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
    );
  }
}
