

import 'package:flutter/material.dart';

Widget mathCharacter(){
  return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD56F),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFB347),
              width: 4,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Face
              Positioned(
                top: 25,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Eyes
              Positioned(
                top: 35,
                left: 30,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 35,
                right: 30,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Smile
              Positioned(
                top: 50,
                child: Container(
                  width: 30,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Math symbol on body
              const Positioned(
                bottom: 20,
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
}