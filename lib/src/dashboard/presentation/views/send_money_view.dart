import 'package:flutter/material.dart';

class SendMoneyView extends StatelessWidget {
  const SendMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Send Money'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
