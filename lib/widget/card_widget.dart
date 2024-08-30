import 'package:flutter/material.dart';
import 'package:quiz_app/ui_helper/text_styles.dart';

class CardWidget extends StatelessWidget {
  final String imageValue;
  final String textValue;
  final Color imgBgColor;
  final Color imgColor;

  CardWidget(
      {required this.imageValue,
      required this.textValue,
      required this.imgBgColor,
      this.imgColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
      child: Container(
        width: double.infinity, //this gives 100% width
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.0),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8)]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: imgBgColor,
                  ),
                  child: Image.asset(
                    imageValue,
                    color: imgColor,
                    width: 30,
                    height: 30,
                  )),
              Container(
                width: 20,
              ),
              Text(textValue, style: textStyle16(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
