import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/data/models/question_model.dart';
import 'package:quiz_app/domain/services/quiz_service.dart';

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
  }

  void skipNextQuestion(int questionIndex) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (state[i].isExpired == true)
          state[i].copyWith(skipToNext: true)
        else
          state[i],
    ];
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

  bool quizComplete() {
    return state.every(
        (question) => question.selectedOption != null || question.isExpired);
  }

  bool allTimersExpired() {
    return state.every((question) => question.isExpired);
  }

  bool get isQuizSubmitted => _isQuizSubmitted;

  void submitQuiz() {
    _isQuizSubmitted = true;
  }

  int nextAvailableQuestionIndex(int currentQuestionIndex) {
    for (var i = 1; i < state.length + 1; i++) {
      int nextQuestionIndex = (currentQuestionIndex + i) % state.length;

      if (!state[nextQuestionIndex].isExpired) {
        return nextQuestionIndex;
      }
    }
    return -1;
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, List<Question>>((ref) {
  return QuizNotifier(QuizService());
});
