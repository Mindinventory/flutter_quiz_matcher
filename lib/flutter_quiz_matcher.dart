library flutter_quiz_matcher;

import 'package:flutter/material.dart';
import 'package:flutter_quiz_matcher/extension/extension.dart';
import 'package:flutter_quiz_matcher/painter/painter.dart';

import 'models/model.dart';

typedef OnScoreUpdate = void Function(UserScore userAnswers);

class QuizMatcher extends StatefulWidget {
  const QuizMatcher(
      {super.key,
      required this.questions,
      required this.answers,
      required this.onScoreUpdated,
      required this.defaultLineColor,
      required this.correctLineColor,
      required this.incorrectLineColor,
      required this.drawingLineColor,
      required this.paddingAround});

  final List<Widget> questions;
  final List<Widget> answers;
  final Color defaultLineColor;
  final Color correctLineColor;
  final Color incorrectLineColor;
  final OnScoreUpdate onScoreUpdated;
  final Color drawingLineColor;
  final EdgeInsets paddingAround;

  @override
  State<QuizMatcher> createState() => _QuizMatcherState();
}

class _QuizMatcherState extends State<QuizMatcher> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final List<QuestionWidget> widgetDataQuestions = [];
  final List<AnswerWidget> widgetDataAnswer = [];
  late List<AnswerWidget> widgetDataAnswerBeforeSuffle = [];
  final List<bool> userAnswers = [];
  List<Line> listLine = [];
  late Offset p1 = Offset.zero;
  late Offset p2 = Offset.zero;
  late int score = 0;
  final List<GlobalKey> globalImageKeyList = [];
  final List<GlobalKey> globalAnswerKeyList = [];
  late List<Offset> points = <Offset>[];
  late int animationIndex = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questions.length; i++) {
      globalImageKeyList.add(GlobalKey());
      globalAnswerKeyList.add(GlobalKey());

      widgetDataQuestions.add(QuestionWidget(
        widget: widget.questions[i],
        key: globalImageKeyList[i],
        color: widget.defaultLineColor,
      ));

      widgetDataAnswer.add(AnswerWidget(
        widget: widget.answers[i],
        key: globalAnswerKeyList[i],
        color: widget.defaultLineColor,
      ));
    }

    widgetDataAnswerBeforeSuffle = widgetDataAnswer;
    for (int i = 0; i < widgetDataQuestions.length; i++) {
      widgetDataQuestions[i].rightAnswerKey = widgetDataAnswerBeforeSuffle[i].key.toString();
    }
    widgetDataAnswer.shuffle();
    for (int i = 0; i < widget.questions.length; i++) {
      listLine.add(Line(panStartOffset: Offset.zero, panEndOffset: Offset.zero, ansSelection: false, colorOfPoint: widget.defaultLineColor));
    }
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            ////
            p2 = details.globalPosition;
            List<Rect> questionsOffset = List.generate(
              widget.questions.length,
              (i) => widgetDataQuestions[i].key.globalPaintBounds!,
            );

            List<Rect> answersOffset = List.generate(
              widget.answers.length,
              (i) => widgetDataAnswer[i].key.globalPaintBounds!,
            );

            RenderBox box = context.findRenderObject() as RenderBox;
            Offset point = box.localToGlobal(details.localPosition);

            bool isInOffset(List<Rect> offsets) {
              return offsets.any(
                (offset) => p2.dx >= offset.left && p2.dx <= offset.right && p2.dy >= offset.top && p2.dy <= offset.bottom,
              );
            }

            if (!isInOffset(questionsOffset) && !isInOffset(answersOffset)) {
              points = List.from(points)..add(point);
            }
            setState(() {});
          },
          onPanEnd: (DragEndDetails details) {
            points.clear();

            List<Rect> questionsOffset = List.generate(
              widget.questions.length,
              (i) => widgetDataQuestions[i].key.globalPaintBounds!,
            );

            List<Rect> answersOffset = List.generate(
              widget.answers.length,
              (i) => widgetDataAnswer[i].key.globalPaintBounds!,
            );

            for (int i = 0; i < questionsOffset.length; i++) {
              if (listLine[i].panStartOffset == Offset.zero && questionsOffset[i].contains(p1)) {
                for (int j = 0; j < answersOffset.length; j++) {
                  if (answersOffset[j].contains(p2)) {
                    if (listLine[j].ansSelection == false) {
                      if (widgetDataQuestions[i].rightAnswerKey.toString() == widgetDataAnswer[j].key.toString()) {
                        score += 1;
                        userAnswers.add(true);
                        widget.onScoreUpdated(UserScore(questionIndex: i, questionAnswer: true));
                        listLine[i].colorOfPoint = widget.correctLineColor;
                      } else {
                        listLine[i].colorOfPoint = widget.incorrectLineColor;
                        userAnswers.add(false);
                        widget.onScoreUpdated(UserScore(questionIndex: i, questionAnswer: false));
                      }
                      listLine[i].panEndOffset = Offset(answersOffset[j].left, answersOffset[j].top + answersOffset[j].height / 2);
                      listLine[i].panStartOffset = Offset(questionsOffset[i].right, questionsOffset[i].bottom - questionsOffset[i].height / 2);
                      listLine[j].ansSelection = true;
                    } else {
                      listLine[i].panStartOffset = Offset.zero;
                      listLine[i].panEndOffset = Offset.zero;
                    }
                  }
                }
                if (animationIndex <= widgetDataAnswer.length) {
                  animationIndex = i + 1;
                } else {
                  animationIndex = 0;
                }
              }
            }
            controller.forward(from: 0);
            setState(() {});
          },
          onPanStart: (details) {
            List<Rect> questionsOffset = [];
            for (int i = 0; i < widget.questions.length; i++) {
              questionsOffset.add(widgetDataQuestions[i].key.globalPaintBounds!);
            }

            for (int i = 0; i < questionsOffset.length; i++) {
              if (questionsOffset[i].contains(details.globalPosition)) {
                p1 = details.globalPosition;
                break; // Exit the loop once a match is found
              }
            }
          },
          child: Stack(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: widget.paddingAround,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          key: widgetDataQuestions[index].key,
                          child: widgetDataQuestions[index].widget,
                        ),
                        const Spacer(),
                        SizedBox(
                          key: widgetDataAnswer[index].key,
                          child: widgetDataAnswer[index].widget,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: widgetDataQuestions.length,
              ),
              Container(
                color: const Color.fromRGBO(25, 0, 0, 0.2),
                child: Stack(
                  children: [
                    for (int i = 0; i < widget.questions.length; i++)
                      CustomPaint(
                        painter: Sketcher(
                            p1: listLine[i].panStartOffset,
                            p2: listLine[i].panEndOffset,
                            color: listLine[i].colorOfPoint,
                            progress: animationIndex == i + 1 ? controller.value : 1),
                      ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(25, 0, 0, 0.2),
                child: CustomPaint(
                  painter: SketcherRealtime(points, widget.drawingLineColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
