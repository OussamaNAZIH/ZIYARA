import 'package:flutter/material.dart';
import 'package:flutter_pfe/Setting/setting.dart';

class Change extends StatefulWidget {
  const Change({super.key});
  @override
  State<Change> createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  bool _obscureText = true;

  final _passwordController = TextEditingController();
  final _mailController = TextEditingController();

  bool mailTextFieldEmpty = true;
  bool emailTextFieldEmpty = true;
  bool passTextFieldEmpty = true;
  @override
  // initState() {
  //   super.initState();
  //   _emailController.addListener(() {
  //     setState(() {
  //       emailTextFieldEmpty = _emailController.text.isEmpty;
  //     });
  //   });
  //   _mailController.addListener(() {
  //     setState(() {
  //       mailTextFieldEmpty = _mailController.text.isEmpty;
  //     });
  //   });
  //   _passwordController.addListener(() {
  //     setState(() {
  //       passTextFieldEmpty = _passwordController.text.isEmpty;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Change Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.pop(context);
            }
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Paramètres du compte'),
                ),
                PopupMenuItem(
                  child: Text('Déconnexion'),
                ),
              ];
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              1.0), // Taille préférée de la barre de délimitation
          child: Divider(
            color: Color.fromARGB(255, 219, 219, 219),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'New Password',
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
                      border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 219, 219, 219)),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: TextFormField(
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return ' Please Enter your password';
                      //   }
                      //   return null;
                      // },
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
                    height: 25,
                  ),
                  const Text(
                    'Confirm Password',
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
                      border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 219, 219, 219)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextFormField(
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
                                // _obscureText = !_obscureText;
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
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: const Color(0xFF06B3C4),
                        ),
                        child: const Center(
                            child: Text('Change Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
