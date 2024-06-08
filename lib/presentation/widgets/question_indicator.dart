// lib/widgets/question_indicator.dart
import 'package:flutter/material.dart';

class QuestionIndicator extends StatelessWidget {
  final bool isCurrent;
  final bool isExpired;
  final bool isAnswered;
  final bool isUnanswered;

  const QuestionIndicator({
    Key? key,
    required this.isCurrent,
    required this.isExpired,
    required this.isAnswered,
    required this.isUnanswered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isExpired) {
      color = Colors.red;
    } else if (isAnswered) {
      color = Colors.blue;
    } else if (isUnanswered) {
      color = Colors.grey;
    } else {
      color = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isCurrent ? Border.all(color: Colors.black, width: 2.0) : null,
      ),
    );
  }
}
