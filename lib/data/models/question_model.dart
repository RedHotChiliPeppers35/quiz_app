class Question {
  final String question;
  final List<String> options;
  final int answerIndex;
  int? selectedOption;
  bool isExpired;
  Duration timeLeft;
  final Duration initialTime;
  bool skipToNext;

  Question({
    required this.question,
    required this.options,
    required this.answerIndex,
    this.selectedOption,
    this.isExpired = false,
    this.timeLeft = const Duration(seconds: 10),
    this.initialTime = const Duration(seconds: 10),
    this.skipToNext = false,
  });

  Question copyWith({
    String? question,
    List<String>? options,
    int? answerIndex,
    int? selectedOption,
    bool? isExpired,
    Duration? timeLeft,
    Duration? initialTime,
    bool? skipToNext,
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
      answerIndex: answerIndex ?? this.answerIndex,
      selectedOption: selectedOption ?? this.selectedOption,
      isExpired: isExpired ?? this.isExpired,
      timeLeft: timeLeft ?? this.timeLeft,
      initialTime: initialTime ?? this.initialTime,
      skipToNext: skipToNext ?? this.skipToNext,
    );
  }
}
