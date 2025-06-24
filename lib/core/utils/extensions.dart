import 'package:flutter/material.dart';

// Extension for Duration to be used with flutter_animate
extension DurationExtension on int {
  Duration get ms => Duration(milliseconds: this);
}
