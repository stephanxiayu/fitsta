import 'package:fitsta/Widget/trainings_card.dart';
import 'package:flutter/material.dart';

class Trainingspage extends StatefulWidget {
  const Trainingspage({super.key});

  @override
  State<Trainingspage> createState() => _TrainingspageState();
}

class _TrainingspageState extends State<Trainingspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            flex: 3,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                    child: TrainingsCard(
                  text: "1.900",
                )),
                Expanded(
                    child: TrainingsCard(
                  text: "gagga",
                ))
              ],
            ))),
        Expanded(flex: 7, child: Container())
      ],
    ));
  }
}
