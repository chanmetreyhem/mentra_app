import 'package:flutter/material.dart';
class StepLine extends StatelessWidget {
  final Color color;
  const StepLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
          ),
        ),
        Expanded(
          child: Container(
            width: 2,
            color: color,
          ),
        ),
      ],
    );
  }
}
