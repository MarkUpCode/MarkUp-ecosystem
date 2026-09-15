import 'package:flutter/material.dart';

import '../../welcome/presentation/widgets/cooperative_partners_view.dart';

class CooperativesPage extends StatelessWidget {
  const CooperativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const CooperativePartnersView(),
      ),
    );
  }
}
