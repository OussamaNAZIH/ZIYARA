import 'package:flutter/material.dart';
import 'package:flutter_pfe/Moduls/Components/page_popView.dart';
import 'package:flutter_pfe/Widgets/Common_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoadText = false;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadApplicationLocalization());
    super.initState();
  }

  Future<void> _loadApplicationLocalization() async {
    try {
      setState(() {
        isLoadText = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // final appTheme = Provider.of<ThemeProvider>(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox(
              // foregroundDecoration:!appTheme.isLightMode ?BoxDecoration(
              //   color: Theme.of(context).backgroundColor.withOpacity(0.4)

              // ):null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/introduction.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: <Widget>[
                  const Expanded(flex: 1, child: SizedBox()),
                  Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     // color: Theme.of(context).dividerColor,
                        //     offset: Offset(1.1, 1.1),
                        //     // blurRadius: 100)
                        //   )
                        // ]
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        child: Image.asset('images/1.png'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Hotel',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AnimatedOpacity(
                    opacity: isLoadText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 420),
                    child: const Text(
                      "Best hotel deals for your holiday",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(flex: 4, child: SizedBox()),
                  AnimatedOpacity(
                      opacity: isLoadText ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 680),
                      child: CommonButton(
                        backgroundColor: const Color(0xFF06B3C4),
                        padding: const EdgeInsets.only(
                            left: 48, right: 48, bottom: 8, top: 8),
                        buttonText: "Get Started",
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Pagepopup()));
                        },
                      )),
                  AnimatedOpacity(
                    opacity: isLoadText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 680),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 24.0 + MediaQuery.of(context).padding.bottom,
                          top: 16),
                      child: const Text(
                        "Already have account",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
