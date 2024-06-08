// lib/screens/quiz_screen.dart
// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quiz_app/presentation/widgets/card.dart';
import 'package:quiz_app/presentation/logics/result_screen.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';
import 'package:quiz_app/presentation/widgets/question_indicator.dart';

class QuizScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    int _currentIndex = 0;
    final questions = watch(quizProvider);
    final quizNotifier = context.read(quizProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (quizNotifier.allTimersExpired()) {
        _showAllTimersExpiredDialog(context);
      }
    });

    return Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(title: const Text('Quiz App')),
        body: questions.isEmpty
            ? const Center(child: Text('No questions available'))
            : Center(
                child: Column(
                  children: [
                    Container(
                      color: Colors.purple.shade100,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: PageView.builder(
                        onPageChanged: (value) {
                          //setState here
                        },
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          return Container(
                            color: Colors.purple.shade100,
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: QuestionCard(
                              questionIndex: index,
                              question: question,
                              onOptionSelected: (optionIndex) {
                                context
                                    .read(quizProvider.notifier)
                                    .selectOption(index, optionIndex);
                              },
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
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen()),
                            ),
                        child: Text("Submit"))
                  ],
                ),
              ));
  }

  void _showAllTimersExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Finished'),
          content: Text('All the timers have expired. The quiz is finished.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
