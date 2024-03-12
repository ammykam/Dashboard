import 'package:flutter/material.dart';

class EatItem extends StatelessWidget {
  final String nutrient;
  final double intake;
  final double goal;
  final Color colorIntake;
  final Color colorGoal;

  EatItem(this.nutrient, this.intake, this.goal, this.colorIntake, this.colorGoal);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: [
               
              Text(
                nutrient,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Spacer(),
              Text(
                nutrient == "Calories" ?"${intake.round()} kcal/ ${goal.round()} kcal" : "${intake.round()} g/ ${goal.round()} g",
                style: TextStyle(
                  color: intake/goal > 1 ? Colors.red[400] :colorIntake,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Container(
            height: 8,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:intake/goal > 1 ? Colors.red[100] : colorGoal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: intake/goal > 1 ? 1:intake/goal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: intake/goal > 1 ? Colors.red[400] : colorIntake,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ) 
      ],
    );
  }
}