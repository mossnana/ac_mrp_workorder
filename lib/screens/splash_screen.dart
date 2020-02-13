import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.deepOrange
            ),
          ),
          Center(
            child: Text(
              'Naraipak',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white
              ),
            ),
          )
        ],
      )
    );
  }
}
