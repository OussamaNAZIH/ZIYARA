import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  addUser() async {
    try {
      // Obtenez l'utilisateur actuellement connecté
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Récupérez l'UID de l'utilisateur
        String userId = user.uid;

        // Créez un nouveau document avec l'ID de l'utilisateur comme ID de document
        DocumentReference userDocRef = users.doc(userId);

        // Ajoutez les informations de l'utilisateur au document
        await userDocRef.set({
          "userid": userDocRef.id,
          // Ajoutez d'autres champs d'utilisateur si nécessaire
          "username": _userController.text.trim(),
          "usergmail": _mailController.text.trim(),
        });

        print("Utilisateur ajouté avec l'ID utilisateur: $userId");
      } else {
        print("Aucun utilisateur n'est actuellement connecté.");
      }
    } catch (e) {
      print("Erreur lors de l'ajout de l'utilisateur: $e");
    }
  }
  // addData() async {
  //   CollectionReference Userref =
  //       FirebaseFirestore.instance.collection("users");
  //   Userref.add({
  //     "UserName": _userController.text.trim(),
  //     "Usergmail": _mailController.text.trim()
  //   });
  //     @override
  // void setState(VoidCallback fn) {
  //   addData();
  //   super.setState(fn);
  // }
  // }

  String email = "", password = "", username = "";
  final _userController = TextEditingController();
  final _mailController = TextEditingController();
  final _paswordController = TextEditingController();
  bool _userTextFieldEmpty = true;
  bool _mailTextFieldEmpty = true;
  bool _passTextFieldEmpty = true;
  final _formkey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();

    // Écouter les changements dans le contenu du TextField
    _userController.addListener(() {
      setState(() {
        _userTextFieldEmpty = _userController.text.isEmpty;
      });
    });
    _mailController.addListener(() {
      setState(() {
        _mailTextFieldEmpty = _mailController.text.isEmpty;
      });
    });
    _paswordController.addListener(() {
      setState(() {
        _passTextFieldEmpty = _paswordController.text.isEmpty;
      });
    });
  }

  resgister() async {
    if (_userController.text != "" && _mailController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        addUser();
        // addData() async {
        //   CollectionReference Userref =
        //       FirebaseFirestore.instance.collection("users");
        //   Userref.add({
        //     "userid": "",
        //     "username": _userController.text.trim(),
        //     "usergmail": _mailController.text.trim(),
        //     "userprofile": "",
        //   });
        //   @override
        //   void setState(VoidCallback fn) {
        //     addData();
        //     super.setState(fn);
        //   }
        // }

        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Image.asset(
                                'images/2.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Center(
                                child: Text(
                                  'Register Success',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  'Congratulation! your account already created.',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Please login to get amazing exprerience',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: const Color(0xFF26c331),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                      },
                                      child: const Text('Go to Login page ',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ])),
                  ),
                ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Color.fromARGB(255, 181, 22, 22),
              content: Text(
                'Password Provided is too Weak',
                style: TextStyle(fontSize: 20),
              )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Color.fromARGB(255, 255, 0, 0),
              content: Text(
                'Account Already exists',
                style: TextStyle(fontSize: 20),
              )));
        }
      }
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                    'Create Account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black),
                  ),
                  Text(
                    'Start learning with create your account',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Username',
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
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      controller: _userController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: _userTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                      controller: _mailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: _mailTextFieldEmpty
                                ? Colors.grey[400]
                                : const Color(0xFF06B3C4),
                          ),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          )),
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
                      controller: _paswordController,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
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
                            color: _passTextFieldEmpty
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
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = _mailController.text;
                            username = _userController.text;
                            password = _paswordController.text;
                          });
                        }
                        resgister();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFF06B3C4),
                        ),
                        child: const Center(
                            child: Text('Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Or using other method',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            'Login',
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
                  //   child: InkWell(
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
                  //             'Sign Up with Google',
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
                  //   child: InkWell(
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
                  //             ' Sign Up with Facebook',
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
    );
  }
}
