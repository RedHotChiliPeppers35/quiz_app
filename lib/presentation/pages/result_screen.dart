import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/presentation/providers/quiz_provider.dart';
import 'welcome_page.dart';

class ResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final questions = watch(quizProvider);
    final score =
        questions.where((q) => q.selectedOption == q.answerIndex).length;


    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          score >= 4
              ? const Text(
                  textAlign: TextAlign.center,
                  "Congratulations!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
              : const Text(
                  textAlign: TextAlign.center,
                  "Do you want to try it again?",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
          const SizedBox(
            height: 10,
          ),
          Text(
            textAlign: TextAlign.center,
            'You correctly answered \n$score out of ${questions.length} questions',
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            height: 40,
          ),
          TextButton(
            onPressed: () {
              context.read(quizProvider.notifier).resetQuiz();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                  (Route route) => false);
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Text(
                  "Try Again",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))),
          )
        ],
      )),
    );
  }
}
