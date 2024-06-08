// lib/widgets/question_card.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/data/models/question_model.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';

class QuestionCard extends StatefulWidget {
  final int questionIndex;
  final Question question;
  final ValueChanged<int> onOptionSelected;

  const QuestionCard({
    Key? key,
    required this.questionIndex,
    required this.question,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late Timer _timer = Timer(Duration.zero, () {});
  late Duration _timeLeft;


  @override
  void initState() {
    super.initState();
    _timeLeft = widget.question.timeLeft;
    if (_timeLeft.inSeconds != 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = Duration(seconds: _timeLeft.inSeconds - 1);
          context
              .read(quizProvider.notifier)
              .updateTimer(widget.questionIndex, _timeLeft);
        });
      } else {
        _timer.cancel();
        setState(() {
           widget.question.isExpired = true;
        });
        context
            .read(quizProvider.notifier)
            .expireQuestion(widget.questionIndex);

        _showExpirationDialog();
      }
    });
  }

  void _showExpirationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Up!'),
          content: Text('The time for this question has expired.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: _timeLeft.inSeconds / 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.question.question,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          ...widget.question.options.asMap().entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              leading: Radio<int>(
                value: entry.key,
                groupValue: widget.question.selectedOption,
                onChanged: widget.question.isExpired
                    ? null
                    : (value) {
                        if (value != null) {
                          widget.onOptionSelected(value);
                        }
                      },
              ),
            );
          }).toList(),

          
        ],
      ),
    );
  }
}
