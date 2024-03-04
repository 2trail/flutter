
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartFarming/Splash.dart';
import 'package:SmartFarming/firebase/fireBringer.dart';

const brown = 0XFFB99470;
const beige = 0XFFFEFAE0;
const greenL = 0XFFA9B388;
const greenD = 0XFF5F6F52;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FireBringer()),
      ],
      child: MaterialApp(

        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: const IconThemeData(color:Color(greenD)),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(greenL) , surface: const Color(beige) ,background:const Color(beige),secondary: const Color(brown) ),

        ),
        darkTheme: ThemeData.dark(

        ),
        home: const Splash(),
      ),
    );
  }
}




