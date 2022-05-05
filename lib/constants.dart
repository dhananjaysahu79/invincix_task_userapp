import 'package:flutter/material.dart';

TextStyle titleStyle = const TextStyle(
  fontWeight: FontWeight.bold
);
TextStyle subtitleStyle =  const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black38
);

TextStyle buttonTextStyle =  const TextStyle(
    fontSize: 18,
    color: Colors.white,
);
TextStyle appBarTextStyle =  const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
);

BorderRadius borderRadius = BorderRadius.circular(40);

LinearGradient containerGradient = const LinearGradient(
   colors: [
      Colors.red,
      Colors.yellow
    ]
);

LinearGradient buttonGradient = const LinearGradient(
   colors: [
      Colors.pink,
      Colors.purple
    ]
);