import 'package:flutter/material.dart';

class ShowMoreDetail extends StatelessWidget {
  const ShowMoreDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(title: Text('Demo')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
