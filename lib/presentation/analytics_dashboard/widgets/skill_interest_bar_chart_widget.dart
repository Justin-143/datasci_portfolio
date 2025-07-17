import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkillInterestBarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> skillData;

  const SkillInterestBarChartWidget({
    super.key,
    required this.skillData,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                      '${skillData[group.x.toInt()]["skill"]}\n${rod.toY.toInt()}%',
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600) ??
                          const TextStyle());
                })),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() < skillData.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Text(
                                    skillData[value.toInt()]["skill"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .textMediumEmphasisLight),
                                    textAlign: TextAlign.center)));
                      }
                      return const Text('');
                    },
                    reservedSize: 30)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${value.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                  color: AppTheme.textMediumEmphasisLight));
                    },
                    reservedSize: 40))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: AppTheme.borderLight.withValues(alpha: 0.5), width: 1)),
        barGroups: skillData.asMap().entries.map((entry) {
          final index = entry.key;
          final skill = entry.value;

          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(
                toY: (skill["interest"] as int).toDouble(),
                gradient: LinearGradient(colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.accentLight,
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                width: 6.w,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: AppTheme.borderLight.withValues(alpha: 0.3))),
          ]);
        }).toList(),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.borderLight.withValues(alpha: 0.5),
                  strokeWidth: 1);
            })));
  }
}
