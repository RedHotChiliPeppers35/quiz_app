import 'package:flutter/material.dart';
import 'package:quiz_app/presentation/pages/quiz_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Welcome to Quiz App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63), // Pink
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Column(
                children: [
                  Text(
                    "Instructions",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "- You can skip for the next question by swiping left and turn back by swiping right.",
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "- For each question, you have 10 seconds, when the timer finishes, you will not able to select any other option.",
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "- If you have answered all questions or all timers are expired, a submit button will appear at the bottom of the screen",
                      style: TextStyle(fontSize: 17, color: Colors.white)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                    (Route route) => false);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: const Color(0xFF3F51B5), // Indigo
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Let's Start",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
