import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/question_model.dart';
import '../../domain/services/quiz_service.dart';

class QuizNotifier extends StateNotifier<List<Question>> {
  QuizNotifier(this._quizService) : super([]) {
    initQuestions();
  }

  final QuizService _quizService;
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
    state = _quizService.getQuestions();
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
    _isQuizSubmitted = true;
  }

  int? getNextUnexpiredQuestionIndex(int currentIndex) {
    for (int i = currentIndex + 1; i < state.length; i++) {
      if (!state[i].isExpired) return i;
    }
    for (int i = 0; i < currentIndex; i++) {
      if (!state[i].isExpired) return i;
    }
    return null;
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, List<Question>>((ref) {
  return QuizNotifier(QuizService());
});
