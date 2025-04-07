import 'package:flutter/material.dart';

class InforCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color; // Thêm tham số màu

  const InforCard({
    super.key, 
    required this.text, 
    required this.icon, 
    required this.onPressed,
    this.color = const Color.fromARGB(255, 186, 189, 191), // Mặc định màu xám
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: color, // Sử dụng màu được truyền vào
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
