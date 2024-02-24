import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: {
        DateTime(2024, 2, 4): 3,
        DateTime(2024, 2, 5): 7,
        DateTime(2024, 2, 8): 10,
        DateTime(2024, 2, 9): 13,
        DateTime(2024, 2, 12): 2,
        DateTime(2024, 2, 14): 8,
        DateTime(2024, 2, 10): 6,
      },
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 40)),
      size: 36,
      defaultColor: Colors.grey.withOpacity(0.5),
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: {
        1: Color(0xFF5E1896),
        2: Color(0xFF5E1896).withOpacity(0.75),
        3: Color(0xFF5E1896).withOpacity(0.65),
        4: Color(0xFF5E1896).withOpacity(0.55),
        5: Color(0xFF5E1896).withOpacity(0.45),
        6: Color(0xFF5E1896).withOpacity(0.35),
        7: Color(0xFF5E1896).withOpacity(0.25),
        8: Color(0xFF5E1896).withOpacity(0.15),
        9: Color(0xFF5E1896).withOpacity(0.05),
        10: Color(0xFF5E1896).withOpacity(0.0),
      },
      onClick: (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }
}
