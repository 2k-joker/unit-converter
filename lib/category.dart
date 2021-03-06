import 'package:flutter/material.dart';
import 'package:unit_converter/unit.dart';

class Category {
  final String name;
  final ColorSwatch color;
  final String iconLocation;
  final List<Unit> units;

  const Category({
    required this.name,
    required this.color,
    required this.iconLocation,
    required this.units,
  });
}
