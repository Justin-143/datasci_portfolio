import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PortfolioAnalyticsCard extends StatefulWidget {
  const PortfolioAnalyticsCard({super.key});

  @override
  State<PortfolioAnalyticsCard> createState() => _PortfolioAnalyticsCardState();
}

class _PortfolioAnalyticsCardState extends State<PortfolioAnalyticsCard> {
  int touchedIndex = -1;

  final List<Map<String, dynamic>> analyticsData = [
    {
      "metric": "Views",
      "value": 2847,
      "change": "+12.5%",
      "color": AppTheme.lightTheme.colorScheme.primary,
    },
    {
      "metric": "Downloads",
      "value": 156,
      "change": "+8.3%",
      "color": AppTheme.lightTheme.colorScheme.tertiary,
    },
    {
      "metric": "Engagement",
      "value": 89.2,
      "change": "+15.7%",
      "color": Color(0xFF38A169),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Analytics',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 25.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildMetricsList(),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    flex: 2,
                    child: _buildChart(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsList() {
    return Column(
      children: analyticsData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> data = entry.value;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                touchedIndex = touchedIndex == index ? -1 : index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                  bottom: index < analyticsData.length - 1 ? 1.h : 0),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: touchedIndex == index
                    ? (data["color"] as Color).withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: touchedIndex == index
                      ? data["color"] as Color
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: touchedIndex == index ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["metric"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    data["metric"] == "Engagement"
                        ? "${data["value"]}%"
                        : "${data["value"]}",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    data["change"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Color(0xFF38A169),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.w),
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
            centerSpaceRadius: 30,
            sections: _buildPieChartSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return analyticsData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> data = entry.value;
      bool isTouched = index == touchedIndex;
      double fontSize = isTouched ? 12 : 10;
      double radius = isTouched ? 35 : 30;

      double value = data["metric"] == "Engagement"
          ? (data["value"] as double) / 100 * 360
          : (data["value"] as int).toDouble() / 3000 * 360;

      return PieChartSectionData(
        color: data["color"] as Color,
        value: value,
        title: isTouched ? '${data["metric"]}' : '',
        radius: radius,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      );
    }).toList();
  }
}
