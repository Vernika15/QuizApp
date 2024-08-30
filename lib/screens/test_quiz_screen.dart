import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/ui_helper/text_styles.dart';

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });
}

Future<List<QuizQuestion>> fetchQuizData(int catVal) async {
  final response = await http
      .get(Uri.parse('https://opentdb.com/api.php?amount=10&category=$catVal'));
  print('API url: https://opentdb.com/api.php?amount=10&category=$catVal');

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    return data.map((questionData) {
      return QuizQuestion(
        question: questionData['question'],
        correctAnswer: questionData['correct_answer'],
        incorrectAnswers: List<String>.from(questionData['incorrect_answers']),
      );
    }).toList();
  } else {
    throw Exception('Failed to load quiz data');
  }
}

class TestQuizScreen extends StatefulWidget {
  int catVal;
  Color colorVal;
  String nameVal;
  String imageVal;

  TestQuizScreen(
      {required this.catVal,
      required this.colorVal,
      required this.nameVal,
      required this.imageVal});

  @override
  State<TestQuizScreen> createState() => _TestQuizScreenState();
}

class _TestQuizScreenState extends State<TestQuizScreen> {
  List<QuizQuestion> quizQuestions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  Timer? questionTimer;
  int remainingSeconds = 10;
  late int _receivedCatVal;
  String? selectedAnswer;
  bool answerIsCorrect = false;
  bool showResult = false;
  final List<String> alphabetPrefixes = ['A', 'B', 'C', 'D'];
  late Color _receivedColorVal;
  late String _receivedNameVal;
  late String _receivedImageVal;
  List<bool?> userAnswers = [];
  int unattemptedQuestions = 0;
  HtmlUnescape htmlUnescape = HtmlUnescape();

  // Method will reset the quiz to first question
  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      answerIsCorrect = false;
      showResult = false;
      startTimer(); // Start the timer for the first question
      userAnswers = [];
    });
  }

  // Method will move to next question whenever user clicks on next button
  void moveToNextQuestion() {
    setState(() {
      questionTimer
          ?.cancel(); // Cancel the timer when moving to the next question
      if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        if (selectedAnswer == null) {
          unattemptedQuestions++;
        }
        selectedAnswer = null; // Reset selected answer
        answerIsCorrect = false;
        showResult = false;
        startTimer(); // Start the timer for the next question
      } else {
        // Show a dialog or navigate to a result screen when all questions are answered.
      }
    });
  }

  // Method to check selected answer whether it is correct or incorrect
  void checkAnswer(String selectedAnswer) {
    setState(() {
      // questionTimer?.cancel(); // Cancel the timer when an answer is selected
      this.selectedAnswer = selectedAnswer;
      if (selectedAnswer == 'null') {
        unattemptedQuestions++;
      } else {
        answerIsCorrect =
            selectedAnswer == quizQuestions[currentQuestionIndex].correctAnswer;
        userAnswers
            .add(answerIsCorrect); // Add the correctness of the current answer
        showResult = true;

        Future.delayed(Duration(seconds: 100), () {
          setState(() {
            showResult = false;

            if (answerIsCorrect) {
              score++;
            }

            if (currentQuestionIndex < quizQuestions.length - 1) {
              currentQuestionIndex++;
              selectedAnswer = 'null'; // Reset selected answer
              startTimer(); // Start the timer for the next question
            }
          });
        });
      }
    });
  }

  // Method to handle the timer expiration
  void handleTimerExpiration() {
    setState(() {
      if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        startTimer();
      } else {
        int correctAnswersCount =
            userAnswers.where((answer) => answer == true).length;
        score = correctAnswersCount;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(
                  score: score, unattemptedQuestions: unattemptedQuestions)),
        );
      }
    });
  }

  // Method to start the timer
  void startTimer() {
    remainingSeconds = 10; // Reset the remaining seconds for each question
    questionTimer?.cancel(); // Cancel the previous timer if it exists
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          questionTimer?.cancel(); // Cancel the timer when time is up
          handleTimerExpiration();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Accessing the data passed from the constructor
    _receivedCatVal = widget.catVal;
    _receivedColorVal = widget.colorVal;
    _receivedNameVal = widget.nameVal;
    _receivedImageVal = widget.imageVal;

    // fetching api to get the quiz data for particular category
    fetchQuizData(_receivedCatVal).then((data) {
      setState(() {
        quizQuestions = data;
        resetQuiz(); // Start the quiz by resetting it
      });
    });
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('Are you sure you want to cancel the quiz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Pop the dialog
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Pop the dialog
                    Navigator.pop(context); // Pop the QuizScreen
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

        // Return true to exit the app if the user confirms
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.lightGreen,
        ),
        body: quizQuestions.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 50.0),
                child: Container(
                  width: double.infinity, //this gives 100% width
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 8)
                      ]),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Image.asset(
                                _receivedImageVal,
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(_receivedNameVal,
                                  textAlign: TextAlign.center,
                                  style: textStyle21(
                                      color: _receivedColorVal,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Question ${currentQuestionIndex + 1}/${quizQuestions.length}',
                                textAlign: TextAlign.center,
                                style: textStyle16(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Text(
                                htmlUnescape.convert(
                                    quizQuestions[currentQuestionIndex]
                                        .question),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 16),
                              // Display answer options
                              ...quizQuestions[currentQuestionIndex]
                                  .incorrectAnswers
                                  .asMap() // Use asMap to get the index along with the answer
                                  .map(
                                    (index, answer) => MapEntry(
                                      index,
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                            onPressed: () =>
                                                checkAnswer(answer),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: showResult &&
                                                      answerIsCorrect &&
                                                      answer == selectedAnswer
                                                  ? Colors.green.withOpacity(
                                                      0.2) // Correct answer
                                                  : showResult &&
                                                          !answerIsCorrect &&
                                                          answer ==
                                                              selectedAnswer
                                                      ? Colors.red.withOpacity(
                                                          0.2) // Incorrect answer
                                                      : null, // Default color
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  child: Text(
                                                      '${alphabetPrefixes[index]}',
                                                      style: textStyle16(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  backgroundColor: showResult &&
                                                          answerIsCorrect &&
                                                          answer ==
                                                              selectedAnswer
                                                      ? Colors
                                                          .green // Correct answer
                                                      : showResult &&
                                                              !answerIsCorrect &&
                                                              answer ==
                                                                  selectedAnswer
                                                          ? Colors
                                                              .red // Incorrect answer
                                                          : null, // Default color
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                    flex: 8,
                                                    child: Text(answer,
                                                        style: textStyle16())),
                                              ],
                                            )),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                    onPressed: () => checkAnswer(
                                        quizQuestions[currentQuestionIndex]
                                            .correctAnswer),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: showResult &&
                                              answerIsCorrect &&
                                              quizQuestions[
                                                          currentQuestionIndex]
                                                      .correctAnswer ==
                                                  selectedAnswer
                                          ? Colors.green.withOpacity(
                                              0.2) // Correct answer
                                          : showResult &&
                                                  !answerIsCorrect &&
                                                  quizQuestions[
                                                              currentQuestionIndex]
                                                          .correctAnswer ==
                                                      selectedAnswer
                                              ? Colors.red.withOpacity(
                                                  0.2) // Incorrect answer
                                              : null, // Default color
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Text('D',
                                              style: textStyle16(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          backgroundColor: showResult &&
                                                  answerIsCorrect &&
                                                  quizQuestions[
                                                              currentQuestionIndex]
                                                          .correctAnswer ==
                                                      selectedAnswer
                                              ? Colors.green // Correct answer
                                              : showResult &&
                                                      !answerIsCorrect &&
                                                      quizQuestions[
                                                                  currentQuestionIndex]
                                                              .correctAnswer ==
                                                          selectedAnswer
                                                  ? Colors
                                                      .red // Incorrect answer
                                                  : null, // Default color
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                            flex: 8,
                                            child: Text(
                                                quizQuestions[
                                                        currentQuestionIndex]
                                                    .correctAnswer,
                                                style: textStyle16())),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                      // Display remaining time for the current question
                      Text(
                        'Time left: $remainingSeconds seconds',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      if (currentQuestionIndex < quizQuestions.length - 1)
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                moveToNextQuestion();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreen),
                              child: Text('Next'),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                questionTimer
                                    ?.cancel(); // Cancel the timer when time is up
                                handleTimerExpiration();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreen),
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
