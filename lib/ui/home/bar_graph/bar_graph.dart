import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/main.dart';

import 'bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    // initialize bar data
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thurAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarData.initializeBarData();
    return Stack(
      children: [
     

        BarChart(
          BarChartData(
            maxY: 100,
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTiles,
              )),
            ),
            //show bar touch data
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBorder: BorderSide(color: Colors.white54, width: 1),
                tooltipBgColor: AppColors.lightbg,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String weekDay = '';
                  switch (group.x.toInt()) {
                    case 0:
                      weekDay = 'Sunday';
                      break;
                    case 1:
                      weekDay = 'Monday';
                      break;
                    case 2:
                      weekDay = 'Tuesday';
                      break;
                    case 3:
                      weekDay = 'Wednesday';
                      break;
                    case 4:
                      weekDay = 'Thursday';
                      break;
                    case 5:
                      weekDay = 'Friday';
                      break;
                    case 6:
                      weekDay = 'Saturday';
                      break;
                  }
                  return BarTooltipItem(
                    weekDay + '\n' + weeklySummary[groupIndex].toString(),
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),

            
            
            
            
            barGroups: myBarData.barData
                .map(
                  (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      

                      BarChartRodData(
                          toY: data.y,
                          borderSide: BorderSide(color: Colors.white, width: 0.1),

                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              Color.fromARGB(255, 50, 10, 83), // Adjust the opacity as needed
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          rodStackItems: [
                            // add rod stack items here
                            
                            
                          ],
                          //show percentage on top of bar

                          width: 27,
                          borderRadius: BorderRadius.circular(8),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: false,
                            toY: 100,
                            color: AppColors.backgroundColor,
                            
                          )),

                         



                          

                        
                   
                      
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.white54
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('S', style: style);
      break;
    case 1:
      text = Text('M', style: style);
      break;
    case 2:
      text = Text('T', style: style);
      break;
    case 3:
      text = Text('W', style: style);
      break;
    case 4:
      text = Text('Th', style: style);
      break;
    case 5:
      text = Text('F', style: style);
      break;
    case 6:
      text = Text('Sa', style: style);
      break;

    default:
      text = Text('', style: style);
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
