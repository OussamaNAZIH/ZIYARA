import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pfe/Screens/Login.dart';
import 'package:flutter_pfe/Screens/Registration.dart';
import 'package:flutter_pfe/Widgets/Common_button.dart';

class Pagepopup extends StatefulWidget {
  const Pagepopup({super.key});

  @override
  State<Pagepopup> createState() => _PagepopupState();
}

class _PagepopupState extends State<Pagepopup> {
  var pageController = PageController(initialPage: 0);

  late Timer sliderTime;
  var currentShowIndex = 0;
  @override
  void initState() {
    sliderTime = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (currentShowIndex == 0) {
        pageController.animateTo(MediaQuery.of(context).size.width,
            duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 1) {
        pageController.animateTo(MediaQuery.of(context).size.width * 2,
            duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 2) {
        pageController.animateTo(0,
            duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    sliderTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: MediaQuery.of(context).padding.top,
      ),
      Expanded(
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              currentShowIndex = index;
            });
          },
          controller: pageController,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/introduction1.png',
                  height: 250,
                ),
                const Text(
                  "Find hotels",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Text(
                    "look around best hotels the city and book them eaisly",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                row()
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/introduction2.png',
                  height: 250,
                ),
                const Text(
                  "Book them",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Text(
                    "no advance payment just book now and pay at hotel.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                row()
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/introduction3.png',
                  height: 250,
                ),
                const Text(
                  "Let's travel",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Text(
                    "All set just pack up dood and make some mood ",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                row()
              ],
            )
          ],
        ),
      ),
      CommonButton(
        backgroundColor: const Color(0xFF06B3C4),
        padding: const EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 8),
        buttonText: "Login",
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        },
      ),
      CommonButton(
        backgroundColor: const Color(0xFF06B3C4),
        padding: const EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 8),
        buttonText: "Create account",
        textColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Registration()));
        },
      ),
      const SizedBox(
        height: 30,
      )
    ]));
  }

  Widget row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        currentShowIndex == 0
            ? const Icon(Icons.circle, size: 10, color: Color(0xFF06B3C4))
            : const Icon(
                Icons.circle_outlined,
                size: 10,
                color: Color(0xFF06B3C4),
              ),
        currentShowIndex == 1
            ? const Icon(Icons.circle, size: 10, color: Color(0xFF06B3C4))
            : const Icon(
                Icons.circle_outlined,
                size: 10,
                color: Color(0xFF06B3C4),
              ),
        currentShowIndex == 2
            ? const Icon(Icons.circle, size: 10, color: Color(0xFF06B3C4))
            : const Icon(
                Icons.circle_outlined,
                size: 10,
                color: Color(0xFF06B3C4),
              ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_pfe/Moduls/appLocalizations.dart';
// import 'package:flutter_pfe/generated/l10n.dart';
// import 'package:flutter_pfe/utils/text_styles.dart';

// class PagePopup extends StatelessWidget {
//   final PageViewData imageData;
//   const PagePopup({super.key, required this.imageData});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           flex: 8,
//           child: Center(
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: Image.asset(imageData.assetImage, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//         Expanded(
//             flex: 1,
//             child: Container(
//                 child: Text(
//               AppLocalizations(context).of(imageData.titleText),
//               textAlign: TextAlign.center,
//               style: TextStyles(context)
//                   .getTitleStyle()
//                   .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
//             ))),
//         const Expanded(flex: 1, child: SizedBox())
//       ],
//     );
//   }
// }

// class PageViewData {
//   final String titleText;
//   final String subText;
//   final String assetImage;

//   PageViewData(
//       {required this.titleText,
//       required this.subText,
//       required this.assetImage});
// }
