





import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oralprep/main.dart';
import 'package:radar_chart/radar_chart.dart';

class RadarChartExample extends StatefulWidget {
  RadarChartExample({Key? key}) : super(key: key);

  @override
  State<RadarChartExample> createState() => _RadarChartExampleState();
}

class _RadarChartExampleState extends State<RadarChartExample> {
  int _length = 3;
  List<double> values1 = [0.4, 0.8, 0.65, 0.7, 0.9, 0.8, 0.7];

  void _incrementCounter() {
    setState(() {
      final random = Random(12341);
      _length++;
      values1.add(random.nextDouble());
      // values2.add(random.nextDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        color: AppColors.backgroundColor,
        child: Center(
          child: RadarChart(
            length: _length,
            radius: 150,
            initialAngle: pi / 3,
            vertices: [
              CustomAppBar(),
              CustomAppBar(),
              CustomAppBar(),
            ],
            //backgroundColor: Colors.white,
            //borderStroke: 2,
            //borderColor: Colors.red.withOpacity(0.4),
            radialStroke: 2,
            radialColor: Colors.grey,
            radars: [
              RadarTile(
                values: values1,
                borderStroke: 2,
                borderColor: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.4),
              ),
              // RadarTile(
              //   values: values2,
              //   borderStroke: 2,
              //   borderColor: Colors.blue,
              //   backgroundColor: Colors.blue.withOpacity(0.4),
              // ),
            ],
          ),
        ),
      );

  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Custom AppBar'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
