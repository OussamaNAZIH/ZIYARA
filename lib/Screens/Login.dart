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
          context, MaterialPageRoute(builder: (context) => const TabScreen()));
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 20),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            content: Text(
              'Wrong Password Provided by User',
              style: TextStyle(fontSize: 20),
            )));
      }
    }
  }

  final _formke = GlobalKey<FormState>();
  forgetpassword() async {
    try {
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(255, 22, 181, 35),
          content: Text(
            'Password sent',
            style: TextStyle(fontSize: 20),
          )));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MapsScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(255, 181, 22, 22),
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 20),
            )));
      }
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
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
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  const Text(
                                                    'Forgot Password',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    'Enter your Email',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    'Email',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
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
                                                      controller:
                                                          _mailController,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .email_outlined,
                                                                color: mailTextFieldEmpty
                                                                    ? Colors.grey[
                                                                        400]
                                                                    : const Color(
                                                                        0xFF06B3C4),
                                                              ),
                                                              hintText:
                                                                  'Enter your email',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .grey[500],
                                                              )),
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_formke
                                                            .currentState!
                                                            .validate()) {
                                                          email =
                                                              _mailController
                                                                  .text;
                                                        }
                                                        forgetpassword();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          color: const Color(
                                                              0xFF06B3C4),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                                'Send Code',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ))),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                ]),
                                          )),
                                    ),
                                  ));
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
                            Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height: 60,
                              width: 60,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Image.network(
                              'https://www.edigitalagency.com.au/wp-content/uploads/Facebook-logo-blue-circle-large-transparent-png.png',
                              height: 40,
                              width: 40,
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
