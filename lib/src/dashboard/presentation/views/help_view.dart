import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/common/widgets/nested_back_button.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Help'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: const NestedBackButton(),
      ),
    );
  }
}
