import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProjectPopularityPieChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> projectData;

  const ProjectPopularityPieChartWidget({
    super.key,
    required this.projectData,
  });

  @override
  State<ProjectPopularityPieChartWidget> createState() =>
      _ProjectPopularityPieChartWidgetState();
}

class _ProjectPopularityPieChartWidgetState
    extends State<ProjectPopularityPieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildPieChartSections(),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.projectData.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              final colors = _getProjectColors();

              return Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project["name"] as String,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${project["percentage"]}%',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.textMediumEmphasisLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = _getProjectColors();

    return widget.projectData.asMap().entries.map((entry) {
      final index = entry.key;
      final project = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.sp : 12.sp;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: (project["percentage"] as int).toDouble(),
        title: '${project["percentage"]}%',
        radius: radius,
        titleStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      );
    }).toList();
  }

  List<Color> _getProjectColors() {
    return [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.accentLight,
      AppTheme.successLight,
      AppTheme.warningLight,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
    ];
  }
}
