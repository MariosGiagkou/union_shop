import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SiteHeader(),
          Expanded(
            child: Center(
              child: Text(
                'Collections',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SiteFooter(),
        ],
      ),
    );
  }
}
