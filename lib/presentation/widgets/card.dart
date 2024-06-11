import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/data/models/question_model.dart';
import 'package:quiz_app/domain/services/quiz_service.dart';
import 'package:quiz_app/presentation/pages/result_screen.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';

class QuestionCard extends StatefulWidget {
  final int questionIndex;
  final Question question;
  final ValueChanged<int> onOptionSelected;
  final bool isCurrent;
  final bool isQuizSubmitted;
  final bool isSkip;
  final PageController pageController;

  const QuestionCard({
    super.key,
    required this.pageController,
    required this.questionIndex,
    required this.question,
    required this.onOptionSelected,
    required this.isCurrent,
    required this.isQuizSubmitted,
    required this.isSkip,
  });

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

        if (!widget.isQuizSubmitted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.read(quizProvider.notifier).allTimersExpired() ==
                true) {
              _showAllTimersExpiredDialog(context);
            } else {
              _showExpirationDialog();
            }
            context
                .read(quizProvider.notifier)
                .skipNextQuestion(widget.questionIndex);
            widget.question.skipToNext = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _showExpirationDialog() {
    if (widget.isQuizSubmitted) return;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Times Up!'),
          content: const Text('The time for this question has expired.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.pageController.hasClients) {
                  log("ATA");
                  int index = context
                      .read(quizProvider.notifier)
                      .nextAvailableQuestionIndex(widget.questionIndex);
                  if (index != -1)
                    widget.pageController.animateToPage(index,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn);
                  else
                    context.read(quizProvider.notifier).submitQuiz();
                }
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAllTimersExpiredDialog(BuildContext context) {
    if (context.read(quizProvider.notifier).isQuizSubmitted) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Finished'),
          content:
              const Text('All the timers have expired. The quiz is finished.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const ResultScreen()),
                    (Route route) => false);
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: const Color(0xFF3F51B5), // Indigo
              value: _timeLeft.inSeconds / 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.question.question,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
