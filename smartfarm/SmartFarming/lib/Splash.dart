import 'package:flutter/material.dart';

import 'HomePage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override

  void initState() {
    super.initState();
    splashTimeOut();

  }
  void splashTimeOut()async{
    await Future.delayed(const Duration(milliseconds: 5000),(){});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=>const HomePage()));

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset("images/plantSplash.gif"),
    );
  }
}
