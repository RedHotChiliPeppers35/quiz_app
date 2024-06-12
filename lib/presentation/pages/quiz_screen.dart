// lib/screens/quiz_screen.dart
// lib/screens/quiz_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quiz_app/presentation/Widgets/card.dart';
import 'package:quiz_app/presentation/pages/result_screen.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';
import 'package:quiz_app/presentation/Widgets/question_indicator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final questions = watch(quizProvider);
        final quizNotifier = watch(quizProvider.notifier);

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
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              if (context
                                  .read(quizProvider.notifier)
                                  .isExpired(index)) {
                                log("expired question");

                                int myIndex = context
                                    .read(quizProvider.notifier)
                                    .nextAvailableQuestionIndex(index);
                                log(myIndex.toString());
                                if (_pageController.hasClients) {
                                  _pageController.animateToPage(myIndex,
                                      duration: Duration(milliseconds: 10),
                                      curve: Curves.bounceIn);
                                }
                              }
                              _currentIndex = index;
                              log(_currentIndex.toString());
                            });
                          },
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final _isSkip = questions[index].skipToNext;
                            final question = questions[index];
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: QuestionCard(
                                pageController: _pageController,
                                isSkip: _isSkip,
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

  Widget submitButton(BuildContext context, QuizNotifier quizNotifier) {
    return TextButton(
      onPressed: () {
        quizNotifier.submitQuiz();

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ResultScreen()),
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
