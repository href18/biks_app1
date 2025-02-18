import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Biks/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.delayed(Duration(milliseconds: 1350), () {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SecondScreen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(
                    'lib/assets/images/Biks_industriopplaering_oransje.png'),
                width: 150,
                height: 150),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Image(
                image: AssetImage(
                  "lib/assets/Entellix_transparent-.png",
                ),
                width: 120,
                height: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
