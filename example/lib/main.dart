import 'package:flutter/material.dart';
import 'package:flutter_quiz_matcher/flutter_quiz_matcher.dart';
import 'package:flutter_quiz_matcher/models/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  List<String> listImagesLocations = ['assets/images/bell.png', 'assets/images/book.png', 'assets/images/home.png', 'assets/images/google.jpeg'];
  List<String> listAnswer = ['bell', 'book', 'home', 'google'];

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter picture matching package',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizMatcher(
        questions: [
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Image.asset(listImagesLocations[0]),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Image.asset(listImagesLocations[1]),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Image.asset(listImagesLocations[2]),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Image.asset(listImagesLocations[3]),
          ),
        ],
        answers: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Text(listAnswer[0]),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Text(listAnswer[1]),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Text(listAnswer[2]),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
            width: 100,
            height: 100,
            child: Text(listAnswer[3]),
          ),
        ],
        defaultLineColor: Colors.black,
        correctLineColor: Colors.green,
        incorrectLineColor: Colors.red,
        drawingLineColor: Colors.black,
        onScoreUpdated: (UserScore userAnswers) {
          print(userAnswers.questionIndex);
          print(userAnswers.questionAnswer);
        },
        paddingAround: EdgeInsets.all(8),
      ),
    );
  }
}
