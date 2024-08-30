import 'package:flutter/material.dart';
import 'package:quiz_app/screens/practice_quiz_screen.dart';
import 'package:quiz_app/screens/test_quiz_screen.dart';
import 'package:quiz_app/ui_helper/text_styles.dart';

class ColorData {
  final Color color;
  final String name;
  final int catVal;
  final String image;

  ColorData(this.color, this.name, this.catVal, this.image);
}

var categoryArr = <ColorData>[
  ColorData(Colors.cyan, 'General Knowledge', 9, 'assets/images/gk.png'),
  ColorData(Colors.greenAccent, 'Entertainment: Books', 10,
      'assets/images/books.png'),
  ColorData(
      Colors.lightGreen, 'Entertainment: Film', 11, 'assets/images/film.png'),
  ColorData(
      Colors.redAccent, 'Entertainment: Music', 12, 'assets/images/music.png'),
  ColorData(Colors.deepOrange, 'Entertainment: Musicals & Theatres', 13,
      'assets/images/musical_theatre.png'),
  ColorData(
      Colors.amber, 'Entertainment: Television', 14, 'assets/images/tv.png'),
  ColorData(Colors.purple.shade300, 'Entertainment: Video Games', 15,
      'assets/images/video_games.png'),
  ColorData(Colors.pink.shade300, 'Entertainment: Board Games', 16,
      'assets/images/board_games.png'),
  ColorData(Colors.cyan, 'Science & Nature', 17, 'assets/images/science.png'),
  ColorData(Colors.greenAccent, 'Science: Computers', 18,
      'assets/images/computers.png'),
  ColorData(Colors.lightGreen, 'Science: Mathematics', 19,
      'assets/images/mathematics.png'),
  ColorData(Colors.redAccent, 'Mythology', 20, 'assets/images/mythology.png'),
  ColorData(Colors.deepOrange, 'Sports', 21, 'assets/images/sports.png'),
  ColorData(Colors.amber, 'Geography', 22, 'assets/images/geography.png'),
  ColorData(Colors.purple.shade300, 'History', 23, 'assets/images/history.png'),
  ColorData(Colors.pink.shade300, 'Politics', 24, 'assets/images/politics.png'),
  ColorData(Colors.cyan, 'Art', 25, 'assets/images/art.png'),
  ColorData(
      Colors.greenAccent, 'Celebrities', 26, 'assets/images/celebrity.png'),
  ColorData(Colors.lightGreen, 'Animals', 27, 'assets/images/animals.png'),
  ColorData(Colors.redAccent, 'Vehicles', 28, 'assets/images/vehicles.png'),
  ColorData(Colors.deepOrange, 'Entertainment: Comics', 29,
      'assets/images/comic.png'),
  ColorData(Colors.amber, 'Science: Gadgets', 30, 'assets/images/gadgets.png'),
  ColorData(Colors.purple.shade300, 'Entertainment: Japanese Anime & Manga', 31,
      'assets/images/manga.png'),
  ColorData(Colors.pink.shade300, 'Entertainment: Cartoon & Animations', 32,
      'assets/images/cartoons.png'),
];

class CategoryScreen extends StatelessWidget {
  String mode;

  CategoryScreen({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: categoryArr[index].color),
                  child: Center(
                      child: Text(categoryArr[index].name,
                          textAlign: TextAlign.center,
                          style: textStyle16(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => mode == 'Test Mode'
                            ? TestQuizScreen(
                                catVal: categoryArr[index].catVal,
                                colorVal: categoryArr[index].color,
                                nameVal: categoryArr[index].name,
                                imageVal: categoryArr[index].image)
                            : PracticeQuizScreen(
                                catVal: categoryArr[index].catVal,
                                colorVal: categoryArr[index].color,
                                nameVal: categoryArr[index].name,
                                imageVal: categoryArr[index].image)),
                  );
                },
              );
            },
            itemCount: categoryArr.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            )),
      ),
    );
  }
}
