import 'package:quiz_app/data/models/question_model.dart';

class QuizService {
  List<Question> getQuestions() {
    return [
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
}
