import 'package:flutter/material.dart';

class TextFieldStyleText extends StatelessWidget {
  final String text;

  const TextFieldStyleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.0,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
