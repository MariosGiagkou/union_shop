import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

class PersonalisePage extends StatefulWidget {
  const PersonalisePage({super.key});

  @override
  State<PersonalisePage> createState() => _PersonalisePageState();
}

class _PersonalisePageState extends State<PersonalisePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SiteHeader(),
          Expanded(
            child: Center(
              child: Text('Personalise Page - Coming Soon'),
            ),
          ),
          SiteFooter(),
        ],
      ),
    );
  }
}
