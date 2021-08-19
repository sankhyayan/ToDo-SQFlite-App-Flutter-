import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final double defaultSize;
  final String title;
  final String description;
  TaskCard(
      {required this.defaultSize,
      required this.title,
      required this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: defaultSize * 3, horizontal: defaultSize * 2.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultSize * 2),
      ),
      margin: EdgeInsets.only(bottom: defaultSize * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title == "" ? 'No Title' : title,
            style: TextStyle(
              color: Color(0xFF211551),
              fontSize: defaultSize * 2.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: defaultSize * 1.5),
            child: Text(
              description == "" ? 'No Description' : description,
              style: TextStyle(
                  fontSize: defaultSize * 2,
                  color: Color(0xFF86829D),
                  height: defaultSize * .15),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  final double defaultSize;
  TodoWidget(
      {required this.defaultSize, required this.text, required this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultSize * 2.4,
        vertical: defaultSize * .8,
      ),
      child: Row(
        children: [
          Container(
            width: defaultSize * 2,
            height: defaultSize * 2,
            margin: EdgeInsets.only(
              right: defaultSize * 1.6,
            ),
            decoration: BoxDecoration(
              border: isDone
                  ? null
                  : Border.all(
                      color: Color(0xFF86829D), width: defaultSize * .15),
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(
                defaultSize * .6,
              ),
            ),
            child: Image.asset(
              'assets/images/check_icon.png',
            ),
          ),
          Flexible(
            child: Text(
              text == "" ? "UnNamed ToDo" : text,
              style: TextStyle(
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                fontSize: defaultSize * 2,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                decoration: isDone?TextDecoration.lineThrough:TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
