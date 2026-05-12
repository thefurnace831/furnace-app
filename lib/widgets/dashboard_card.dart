import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String description;
  final double height;
  final VoidCallback? onClick;

  const DashboardCard({super.key, required this.icon, required this.description, required this.height, this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: InkWell(
        onTap: onClick,
        child: Card(
          color: FurnaceColors.paper,
          elevation: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
              ),
              SizedBox(height: 15),
              Text(
                description,
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ),
        ),
      )
    );
  }

}