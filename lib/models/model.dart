import 'package:flutter/cupertino.dart';

class QuestionWidget {
  final Widget widget;
  final GlobalKey key;
  final Color color;
  late String? rightAnswerKey;

  QuestionWidget({required this.widget, required this.key, required this.color, this.rightAnswerKey});
}

class AnswerWidget {
  final Widget widget;
  final GlobalKey key;
  final Color color;

  AnswerWidget({required this.widget, required this.key, required this.color});
}

class Line {
  late Offset panStartOffset;
  late Offset panEndOffset;
  late bool ansSelection;
  late Color colorOfPoint;

  Line({required this.panStartOffset, required this.panEndOffset, required this.ansSelection, required this.colorOfPoint});
}

class UserScore {
  final questionIndex;
  final questionAnswer;

  UserScore({required this.questionIndex, required this.questionAnswer});
}
