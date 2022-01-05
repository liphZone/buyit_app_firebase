import 'package:flutter/material.dart';

Row kTitle(text) {
  return Row(
    children: [
      Text(
        'BUY IT',
        style: TextStyle(color: Colors.black),
      ),
      Spacer(),
      Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    ],
  );
}

//Input Decoration
InputDecoration kInputDecoration(hintText) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );
}
