import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TrafficLineChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> trafficData;

  const TrafficLineChartWidget({
    super.key,
    required this.trafficData,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.borderLight.withValues(alpha: 0.5),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() < trafficData.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                                (trafficData[value.toInt()]["day"] as String),
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                        color:
                                            AppTheme.textMediumEmphasisLight)));
                      }
                      return const Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    interval: 50,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(value.toInt().toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                  color: AppTheme.textMediumEmphasisLight));
                    },
                    reservedSize: 42))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: AppTheme.borderLight.withValues(alpha: 0.5), width: 1)),
        minX: 0,
        maxX: (trafficData.length - 1).toDouble(),
        minY: 0,
        maxY: 300,
        lineBarsData: [
          LineChartBarData(
              spots: trafficData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(),
                    (entry.value["views"] as int).toDouble());
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.accentLight,
              ]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: AppTheme.lightTheme.colorScheme.surface);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    AppTheme.accentLight.withValues(alpha: 0.1),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
        ],
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    if (flSpot.x.toInt() < trafficData.length) {
                      return LineTooltipItem(
                          '${trafficData[flSpot.x.toInt()]["day"]}\n${flSpot.y.toInt()} views',
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600) ??
                              const TextStyle());
                    }
                    return null;
                  }).toList();
                }))));
  }
}
