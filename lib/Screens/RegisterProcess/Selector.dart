import 'package:flutter/material.dart';
import '../../Routes.dart';
import '../../Widgets/RoundButton.dart';

class Selector extends StatelessWidget {
  const Selector({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Image(image: AssetImage("assets/images/splash.jpg")),
                Text(
                  "Welcome to MegaMall !",
                  style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text(
                  "All your home furniture is here",
                  style: TextStyle(color: Colors.black54,fontSize: 15),
                ),
                SizedBox(
                  height: 50,
                ),
                RoundButton(
                  text: "Login",
                  bacground: Colors.white,
                  foreground: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.Login);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButton(
                  text: "Sign Up",
                  bacground: Colors.blue,
                  foreground: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.Signup);
                  },
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}