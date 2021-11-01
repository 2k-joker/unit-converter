import 'package:flutter/material.dart';
import 'package:unit_converter/unit.dart';

class Category {
  final String name;
  final ColorSwatch color;
  final IconData icon;
  final List<Unit> units;

  const Category({
    required this.name,
    required this.color,
    required this.icon,
    required this.units,
  });
}
