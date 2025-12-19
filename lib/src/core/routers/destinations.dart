import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Orders', icon: Icons.receipt),
  Destination(label: 'Products', icon: Icons.apple),
];
