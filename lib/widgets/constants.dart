import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Instance de FirebaseFirestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
