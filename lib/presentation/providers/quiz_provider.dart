// lib/providers/quiz_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/question_model.dart';

class QuizNotifier extends StateNotifier<List<Question>> {
  QuizNotifier() : super([]) {
    initQuestions();
  }

  bool _isQuizSubmitted = false;

  void selectOption(int questionIndex, int optionIndex) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == questionIndex)
          state[i].copyWith(selectedOption: optionIndex)
        else
          state[i],
    ];
  }

  void initQuestions() {
    state = [
      Question(
        question: 'What is the capital of France?',
        options: ['Berlin', 'Madrid', 'Paris'],
        answerIndex: 2,
      ),
      Question(
        question: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter'],
        answerIndex: 1,
      ),
      Question(
        question: 'What is the largest mammal?',
        options: ['Elephant', 'Blue Whale', 'Giraffe'],
        answerIndex: 1,
      ),
      Question(
        question: 'What is the chemical symbol for water?',
        options: ['O2', 'H2O', 'CO2'],
        answerIndex: 1,
      ),
      Question(
        question: 'How many continents are there on Earth?',
        options: ['5', '6', '7'],
        answerIndex: 2,
      ),
    ];
  }

  void resetQuiz() {
    initQuestions();
    state = [
      for (int i = 0; i < state.length; i++)
        state[i].copyWith(timeLeft: Duration(seconds: 10))
    ];
    _isQuizSubmitted = false;
  }

  void stopAllTimers() {
    state = [
      for (int i = 0; i < state.length; i++)
        state[i].copyWith(timeLeft: Duration.zero)
    ];
  }

  void expireQuestion(int questionIndex) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == questionIndex)
          state[i].copyWith(isExpired: true)
        else
          state[i],
    ];
    checkAllTimersExpired();
  }

  void updateTimer(int questionIndex, Duration timeLeft) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == questionIndex)
          state[i].copyWith(timeLeft: timeLeft)
        else
          state[i],
    ];
  }

  void checkAllTimersExpired() {
    if (state.every((question) => question.isExpired)) {
      state = [
        for (int i = 0; i < state.length; i++)
          state[i].copyWith(isExpired: true)
      ];
    }
  }

  bool quizComplete() {
    return state.every(
        (question) => question.selectedOption != null || question.isExpired);
  }

  bool allQuestionsAnswered() {
    return state.every((question) => question.selectedOption != null);
  }

  bool allTimersExpired() {
    return state.every((question) => question.isExpired);
  }

  bool get isQuizSubmitted => _isQuizSubmitted;

  void submitQuiz() {
    resetQuiz();
    _isQuizSubmitted = true;
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, List<Question>>((ref) {
  return QuizNotifier();
});
