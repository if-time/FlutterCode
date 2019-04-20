import 'package:flutter/material.dart';

// 无状态StatelessWidget
class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Question_answer')),
      body: Center(child: Text('Question_answer'),),
    );
  }
}