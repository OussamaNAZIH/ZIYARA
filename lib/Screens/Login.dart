import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Moduls/SplashScreen.dart';
import 'package:flutter_pfe/Screens/Home.dart';
import 'package:flutter_pfe/Screens/MapsScreen.dart';
import 'package:flutter_pfe/Screens/Registration.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:flutter_pfe/Screens/VerificationCode.dart';
import 'package:flutter_pfe/Screens/auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  bool showSpinner = false;

  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mailController = TextEditingController();

  bool mailTextFieldEmpty = true;
  bool emailTextFieldEmpty = true;
  bool passTextFieldEmpty = true;
  @override
  initState() {
    super.initState();

    // Écouter les changements dans le contenu du TextField
    _emailController.addListener(() {
      setState(() {
        emailTextFieldEmpty = _emailController.text.isEmpty;
      });
    });
    _mailController.addListener(() {
      setState(() {
        mailTextFieldEmpty = _mailController.text.isEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        passTextFieldEmpty = _passwordController.text.isEmpty;
      });
    });
  }

  final _formkey = GlobalKey<FormState>();
  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      print('FirebaseAuthException code: ${e.code}');
      if (e.code == 'user-not-found') {
        message = 'No User Found for that Email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong Password Provided by User';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid Email';
      } else {
        message = 'Check Your Password or Your Adress Email';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 17, 0),
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } catch (e) {
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'An unexpected error occurred',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  final _formke = GlobalKey<FormState>();
  Future<void> forgetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 0, 255, 8),
          content: Text(
            'Password reset email sent',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MapsScreen()),
      // );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No User Found for that Email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid Email Address';
      } else {
        message = 'user-not-found';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 17, 0),
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } catch (e) {
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 255, 17, 0),
          content: Text(
            'user-not-found',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Login Account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    Text(
                      'Please login with registered account',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[50],
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' Please Enter your email';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: emailTextFieldEmpty
                                  ? Colors.grey[400]
                                  : const Color(0xFF06B3C4),
                            ),
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            )),
                        onTap: () {},
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[50],
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' Please Enter your password';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.password,
                              color: passTextFieldEmpty
                                  ? Colors.grey[400]
                                  : const Color(0xFF06B3C4),
                            ),
                            hintText: 'Create your password',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Form(
                                    key: _formke,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 30),
                                        const Text(
                                          'Forgot Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Enter your Email',
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Email',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.grey[50],
                                          ),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Your Email';
                                              }
                                              return null;
                                            },
                                            controller: _mailController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                prefixIcon: Icon(
                                                  Icons.email_outlined,
                                                  color: mailTextFieldEmpty
                                                      ? Colors.grey[400]
                                                      : const Color(0xFF06B3C4),
                                                ),
                                                hintText: 'Enter your email',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[500],
                                                )),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_formke.currentState!
                                                  .validate()) {
                                                email = _mailController.text;
                                                // Fermer le showModalBottomSheet avant d'appeler forgetPassword
                                                Navigator.pop(context);
                                                forgetPassword();
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: const Color(0xFF06B3C4),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Send Code',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF06B3C4)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = _emailController.text;
                              password = _passwordController.text;
                            });
                          }
                          userLogin();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0xFF06B3C4),
                          ),
                          child: const Center(
                              child: Text('Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Or using other method',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/1199414.png',
                              height: 50,
                              width: 50,
                            ),
                            // const SizedBox(
                            //   width: 20,
                            // ),
                            Image.asset(
                              'images/Facebook.png',
                              height: 95,
                              width: 95,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Registration()));
                            },
                            child: const Text(
                              'SignUp',
                              style: TextStyle(
                                  color: Color(0xFF06B3C4),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(18),
                    //           color: Colors.white),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Image.network(
                    //             'http://pngimg.com/uploads/google/google_PNG19635.png',
                    //             height: 40,
                    //             width: 40,
                    //           ),
                    //           Text(
                    //             'Sign In with Google',
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 18,
                    //               color: Colors.black,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 25,
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 15),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(18),
                    //           color: Colors.white),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Image.network(
                    //             'https://www.edigitalagency.com.au/wp-content/uploads/Facebook-logo-blue-circle-large-transparent-png.png',
                    //             height: 30,
                    //             width: 30,
                    //           ),
                    //           Text(
                    //             ' Sign In with Facebook',
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 18,
                    //               color: Colors.black,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
