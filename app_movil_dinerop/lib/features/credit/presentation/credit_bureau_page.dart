import 'package:flutter/material.dart';

class CreditBureauPage extends StatelessWidget {
  const CreditBureauPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar buro')),
      body: const Center(
        child: Text('Próximamente podrás consultar tu información del buro.'),
      ),
    );
  }
}
