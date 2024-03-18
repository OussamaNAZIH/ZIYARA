import 'package:flutter/material.dart';

class VerificationCode extends StatelessWidget {
  VerificationCode({super.key, required String }) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Verification',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Revenir à la page précédente
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(
              height: 0,
            ),
            Divider(
              color: Colors.grey[350],
              thickness: 1.0,
              height: 20.0,
            ),
            Image.asset(
              'images/1.png',
              height: 150,
              width: 150,
            ),
            const Center(
              child: Text(
                'Verification Code',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'We have to sent the code verification to',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'h',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF06B3C4),
                ),
                child: TextButton(
                    onPressed: () {
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
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                'We have to sent the code verification to',
                                                style: TextStyle(
                                                    color: Colors.grey[500]),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  color:
                                                      const Color(0xFF26c331),
                                                ),
                                                child: TextButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                        'Go to Homepage ',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ))),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                          ])),
                                ),
                              ));

                      // showModalBottomSheet(
                      //     isScrollControlled: true,
                      //     context: context,
                      //     builder: (context) => Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(horizontal: 25),
                      //           child: SingleChildScrollView(
                      //             child: Padding(
                      //                 padding: EdgeInsets.only(
                      //                     bottom: MediaQuery.of(context)
                      //                         .viewInsets
                      //                         .bottom),
                      //                 child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.stretch,
                      //                     children: [
                      //                       SizedBox(
                      //                         height: 30,
                      //                       ),
                      //                       Image.asset(
                      //                         'images/4.png',
                      //                         height: 100,
                      //                         width: 100,
                      //                       ),
                      //                       SizedBox(
                      //                         height: 25,
                      //                       ),
                      //                       Center(
                      //                         child: Text(
                      //                           'Register Success',
                      //                           style: TextStyle(
                      //                               fontSize: 18,
                      //                               fontWeight:
                      //                                   FontWeight.bold),
                      //                         ),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 10,
                      //                       ),
                      //                       Center(
                      //                         child: Text(
                      //                           'We have to sent the code verification to',
                      //                           style: TextStyle(
                      //                               color: Colors.grey[500]),
                      //                         ),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 30,
                      //                       ),
                      //                       Padding(
                      //                         padding:
                      //                             const EdgeInsets.symmetric(
                      //                                 horizontal: 15),
                      //                         child: Container(
                      //                           decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(18),
                      //                             color: Color(0xFFF44336),
                      //                           ),
                      //                           child: TextButton(
                      //                               onPressed: () {},
                      //                               child: Text(
                      //                                   'Go to Homepage ',
                      //                                   style: TextStyle(
                      //                                     color: Colors.white,
                      //                                   ))),
                      //                         ),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 25,
                      //                       ),
                      //                     ])),
                      //           ),
                      // ));
                    },
                    child: const Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        ));
  }
}
