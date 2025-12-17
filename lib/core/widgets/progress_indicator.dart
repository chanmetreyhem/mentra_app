import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String status;
  final Color color;
  final double value;
  const CustomProgressIndicator({
    super.key,
    required this.status,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Column(
            spacing: 5,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  padding: EdgeInsets.all(2),
                  strokeWidth: 10,
                  color: color,
                  backgroundColor: Colors.black,
                  value: value,
                ),
              ),
              SizedBox(
                height: 20,
                width: double.infinity,
                child: Row(
                  spacing: 4,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 13,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(child: Text("${(value * 100).toStringAsFixed(1)}.%")),
          ),
        ),
      ],
    );
  }
}
