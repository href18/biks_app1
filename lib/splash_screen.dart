import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loftetabell/main.dart';

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
            Image(image: AssetImage('lib/assets/images/biks-logo.png')),
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Image(
                image: AssetImage("lib/assets/Entellix_transparent-.png"),
                width: 130,
                height: 130,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarningMessage extends StatefulWidget {
  const WarningMessage({super.key});

  @override
  State<WarningMessage> createState() => _WarningMessageState();
}

class _WarningMessageState extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: (Center()),
    );
  }
}
