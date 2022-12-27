import 'package:flutter/material.dart';

class TrainingsCard extends StatelessWidget {
  final String? text;

  const TrainingsCard({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      elevation: 9,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text("text"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Center(
                child: Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
