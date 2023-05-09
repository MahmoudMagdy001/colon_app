import 'package:flutter/material.dart';

class StatisticsDetails extends StatefulWidget {
  const StatisticsDetails({super.key});

  @override
  State<StatisticsDetails> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StatisticsDetails> {
  List<String> imagePaths = [
    'assets/images/average_age.png',
    'assets/images/smoking.png',
    'assets/images/avgs.png',
    'assets/images/average_weight.png',
    'assets/images/average_bsa.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Image.asset(
            imagePaths[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
