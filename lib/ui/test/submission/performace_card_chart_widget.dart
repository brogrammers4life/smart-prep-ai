import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/main.dart';

class PerformanceCardChartWidget extends StatefulWidget {
  final String text;
  final List<int> sem_data;
  final List<int> lit_data;
  PerformanceCardChartWidget({Key? key, required this.text, required this.sem_data, required this.lit_data})
      : super(key: key);

  @override
  State<PerformanceCardChartWidget> createState() =>
      _PerformanceCardChartWidgetState();
}

class _PerformanceCardChartWidgetState
    extends State<PerformanceCardChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: 320,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //text
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Semantic Score",
                        style: TextStyle(color: AppColors.primary),
                      ),
                      Text(
                        " VS ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Literal Score",
                        style: TextStyle(color: AppColors.lightPrimary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                                minX: 0,
                                maxX: double.tryParse(
                                    widget.sem_data.length.toString()),
                                minY: 0.0,
                                maxY: 100.0,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Questions No.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    sideTitles: SideTitles(
                                      reservedSize: 20,
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        index++;
                                        // Add 1 to display question number
                                        return Text(
                                          index.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  // leftTitles: AxisTitles(
                
                                  //   // axisNameWidget: Text(
                                  //   //   "Score",
                                  //   //   style: TextStyle(color: Colors.grey),
                                  //   // ),
                                  //   sideTitles: SideTitles(
                                  //     reservedSize: 35,
                                  //     showTitles: true,
                                  //     getTitlesWidget: (value, meta) {
                                  //       int index = value.toInt();
                                  //       // Add 1 to display question number
                                  //       if(value == 100 ){
                                  //         return  SizedBox(
                                  //         width: 20,
                                  //         child: Text(
                                  //           "${index.toString()}%",
                                  //           style: TextStyle(color: Colors.grey),
                                  //         ),
                                  //       );
                                  //       }else{
                                  //         return SizedBox();
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    color: AppColors.primary,
                                    spots:
                                        widget.sem_data.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      int value = entry.value;
                                      return FlSpot(
                                          index.toDouble(), value.toDouble());
                                    }).toList(),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                                minX: 0,
                                maxX: double.tryParse(
                                    widget.lit_data.length.toString()),
                                minY: 0.0,
                                maxY: 100.0,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      "Questions No.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    sideTitles: SideTitles(
                                      reservedSize: 20,
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        index++;
                                        // Add 1 to display question number
                                        return Text(
                                          index.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  // leftTitles: AxisTitles(
                
                                  //   // axisNameWidget: Text(
                                  //   //   "Score",
                                  //   //   style: TextStyle(color: Colors.grey),
                                  //   // ),
                                  //   sideTitles: SideTitles(
                                  //     reservedSize: 35,
                                  //     showTitles: true,
                                  //     getTitlesWidget: (value, meta) {
                                  //       int index = value.toInt();
                                  //       // Add 1 to display question number
                                  //       if(value == 100 ){
                                  //         return  SizedBox(
                                  //         width: 20,
                                  //         child: Text(
                                  //           "${index.toString()}%",
                                  //           style: TextStyle(color: Colors.grey),
                                  //         ),
                                  //       );
                                  //       }else{
                                  //         return SizedBox();
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    color: AppColors.lightPrimary,
                                    spots:
                                        widget.lit_data.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      int value = entry.value;
                                      return FlSpot(
                                          index.toDouble(), value.toDouble());
                                    }).toList(),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
