import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';

class RoomStatusWidget extends StatelessWidget {
  final bool isEditing;
  final IconData icon;

  const RoomStatusWidget(
      {super.key, required this.isEditing, required this.icon});

  @override
  Widget build(BuildContext context) {
    // Colors
    final backgroundColor = isEditing
        ? const Color.fromRGBO(208, 229, 189, 100)
        : const Color.fromRGBO(250, 227, 146, 100);
    final textColor = isEditing
        ? const Color.fromRGBO(92, 131, 76, 100)
        : const Color.fromRGBO(150, 100, 30, 100);

    return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          // Icons
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 16.0),
              Text(
                isEditing ? 'Editing' : 'Viewing',
                style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Text
        ));
  }
}
