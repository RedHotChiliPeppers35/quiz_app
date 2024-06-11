// lib/screens/quiz_screen.dart
// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quiz_app/presentation/widgets/Widgets/card.dart';
import 'package:quiz_app/presentation/widgets/Pages/result_screen.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';
import 'package:quiz_app/presentation/widgets/Widgets/question_indicator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final questions = watch(quizProvider);
        final quizNotifier = watch(quizProvider.notifier);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (quizNotifier.allTimersExpired()) {
            _showAllTimersExpiredDialog(context);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Quiz App'),
          ),
          body: questions.isEmpty
              ? const Center(child: Text('No questions available'))
              : Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: PageView.builder(
                          controller:
                              PageController(initialPage: _currentIndex),
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final question = questions[index];
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: QuestionCard(
                                questionIndex: index,
                                question: question,
                                onOptionSelected: (optionIndex) {
                                  quizNotifier.selectOption(index, optionIndex);
                                },
                                isCurrent: index == _currentIndex,
                                isQuizSubmitted: quizNotifier.isQuizSubmitted,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(questions.length, (index) {
                          final question = questions[index];
                          return QuestionIndicator(
                            isCurrent: index == _currentIndex,
                            isExpired: question.isExpired,
                            isAnswered: question.selectedOption != null &&
                                !question.isExpired,
                            isUnanswered: question.selectedOption == null &&
                                !question.isExpired,
                          );
                        }),
                      ),
                      const Spacer(),
                      quizNotifier.quizComplete()
                          ? submitButton(context, quizNotifier)
                          : hiddenButton(),
                      const Spacer()
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _showAllTimersExpiredDialog(BuildContext context) {
    if (context.read(quizProvider.notifier).isQuizSubmitted) return;
    showDialog(
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
                    MaterialPageRoute(builder: (context) => ResultScreen()),
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

  Widget submitButton(BuildContext context, QuizNotifier quizNotifier) {
    return TextButton(
      onPressed: () {
        quizNotifier.submitQuiz();

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ResultScreen()),
            (Route route) => false);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: 100,
        height: 50,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                color: const Color(0xFF3F51B5), // Indigo,
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget hiddenButton() {
  return TextButton(
    onPressed: () {
      null;
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: 100,
      height: 50,
      child: const Center(
        child: Text(
          "Submit",
          style: TextStyle(
              fontSize: 17,
              color: Colors.transparent,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
