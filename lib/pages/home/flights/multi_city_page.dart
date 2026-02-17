import 'package:expedia/pages/home/flights/widgets/one_way_widget.dart';
import 'package:flutter/material.dart';

class MultiCityPage extends StatefulWidget {
  const MultiCityPage({super.key});

  @override
  State<MultiCityPage> createState() => _MultiCityPageState();
}

class _MultiCityPageState extends State<MultiCityPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [OneWayWidget()]),
    );
  }
}
