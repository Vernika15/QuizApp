import 'package:flutter/material.dart';
import 'package:quiz_app/ui_helper/text_styles.dart';

class ResultScreen extends StatefulWidget {
  int score;
  int unattemptedQuestions;

  ResultScreen({required this.score, required this.unattemptedQuestions});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late int _receivedScoreVal;
  late int _receivesUnattemptedQuestionsVal;
  int wrongScoreVal = 0;
  int completedScoreVal = 0;

  @override
  void initState() {
    super.initState();
    // Accessing the data passed from the constructor
    _receivedScoreVal = widget.score;
    _receivesUnattemptedQuestionsVal = widget.unattemptedQuestions + 1;
    wrongScoreVal = 10 - (_receivedScoreVal + _receivesUnattemptedQuestionsVal);
    completedScoreVal = _receivedScoreVal + wrongScoreVal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Result', style: textStyle26(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0, // Setting this to zero removes the drop shadow
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 30.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Column(children: [
                      Image.asset(
                        'assets/images/trophy.png',
                        width: 120,
                        height: 120,
                      ),
                    ])),
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    child: Column(
                      children: [
                        Text('Total Questions',
                            textAlign: TextAlign.center,
                            style: textStyle26(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 10),
                        Text('10',
                            textAlign: TextAlign.center,
                            style: textStyle26(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Completed',
                                style: textStyle21(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('$completedScoreVal',
                                style: textStyle21(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Correct',
                                style: textStyle21(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            Text('$_receivedScoreVal',
                                style: textStyle21(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Wrong',
                                style: textStyle21(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            Text('$wrongScoreVal',
                                style: textStyle21(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Not Attempted',
                                style: textStyle21(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('$_receivesUnattemptedQuestionsVal',
                                style: textStyle21(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
