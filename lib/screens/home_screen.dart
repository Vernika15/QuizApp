import 'package:flutter/material.dart';
import 'package:quiz_app/screens/category_screen.dart';
import 'package:quiz_app/widget/card_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(mode: 'Test Mode'),
                ),
              );
            },
            child: CardWidget(
              imageValue: 'assets/images/test.png',
              textValue: 'Start Quiz',
              imgBgColor: Colors.indigo,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(mode: 'Practice Mode'),
                ),
              );
            },
            child: CardWidget(
              imageValue: 'assets/images/practice.png',
              textValue: 'Practice Mode',
              imgBgColor: Colors.pink,
            ),
          ),
          // CardWidget(
          //   imageValue: 'assets/images/settings.png',
          //   textValue: 'Settings',
          //   imgBgColor: Colors.cyan,
          // ),
        ],
      ),
    );
  }
}
