// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quiz_provider.dart';

class ResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final questions = watch(quizProvider);
    final score =
        questions.where((q) => q.selectedOption == q.answerIndex).length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar:
            AppBar(automaticallyImplyLeading: false, title: Text('Results')),
        body: Center(
          child: Text('Your score: $score/${questions.length}'),
        ),
      ),
    );
  }
}
