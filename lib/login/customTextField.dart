import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final Function(String)? onChanged; // Nuevo parámetro

  const CustomTextField({
    Key? key,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged, // Se ejecutará cada vez que el usuario escriba
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}
