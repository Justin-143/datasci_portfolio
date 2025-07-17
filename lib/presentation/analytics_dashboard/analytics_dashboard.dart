import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chart_container_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/kpi_carousel_widget.dart';
import './widgets/live_visitor_indicator_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/project_popularity_pie_chart_widget.dart';
import './widgets/skill_interest_bar_chart_widget.dart';
import './widgets/traffic_line_chart_widget.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDateRange = '30 days';
  bool _isLoading = false;
  int _currentBottomIndex = 3; // Analytics tab

  // Mock data for analytics
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Total Views",
      "value": "12,847",
      "trend": "+15.3%",
      "isPositive": true,
      "icon": "visibility"
    },
    {
      "title": "Project Downloads",
      "value": "3,429",
      "trend": "+8.7%",
      "isPositive": true,
      "icon": "download"
    },
    {
      "title": "Profile Visits",
      "value": "8,932",
      "trend": "-2.1%",
      "isPositive": false,
      "icon": "person"
    },
    {
      "title": "Contact Inquiries",
      "value": "247",
      "trend": "+23.5%",
      "isPositive": true,
      "icon": "mail"
    },
  ];

  final List<Map<String, dynamic>> _trafficData = [
    {"day": "Mon", "views": 120},
    {"day": "Tue", "views": 180},
    {"day": "Wed", "views": 150},
    {"day": "Thu", "views": 220},
    {"day": "Fri", "views": 280},
    {"day": "Sat", "views": 190},
    {"day": "Sun", "views": 160},
  ];

  final List<Map<String, dynamic>> _projectPopularityData = [
    {"name": "ML Prediction Model", "percentage": 35},
    {"name": "Data Visualization", "percentage": 28},
    {"name": "NLP Sentiment Analysis", "percentage": 22},
    {"name": "Time Series Forecasting", "percentage": 15},
  ];

  final List<Map<String, dynamic>> _skillInterestData = [
    {"skill": "Python", "interest": 85},
    {"skill": "R", "interest": 72},
    {"skill": "SQL", "interest": 68},
    {"skill": "Tableau", "interest": 55},
    {"skill": "TensorFlow", "interest": 78},
  ];

  final List<Map<String, dynamic>> _kpiData = [
    {
      "label": "Bounce Rate",
      "value": "32.4%",
      "change": "-5.2%",
      "isPositive": true,
      "icon": "trending_down"
    },
    {
      "label": "Avg. Session",
      "value": "4m 23s",
      "change": "+12.8%",
      "isPositive": true,
      "icon": "schedule"
    },
    {
      "label": "Geographic Reach",
      "value": "47 countries",
      "change": "+3",
      "isPositive": true,
      "icon": "public"
    },
    {
      "label": "Mobile Traffic",
      "value": "68.2%",
      "change": "+4.1%",
      "isPositive": true,
      "icon": "phone_android"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onDateRangeChanged(String range) {
    setState(() {
      _selectedDateRange = range;
    });
    _refreshAnalytics();
  }

  void _exportAnalytics() {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Analytics report exported successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    final routes = [
      '/biometric-authentication',
      '/portfolio-dashboard',
      '/projects-gallery',
      '/interactive-resume',
      '/analytics-dashboard',
      '/settings',
    ];

    if (index != 4) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Analytics Dashboard',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        Row(
                          children: [
                            LiveVisitorIndicatorWidget(activeVisitors: 23),
                            SizedBox(width: 3.w),
                            GestureDetector(
                              onTap: _refreshAnalytics,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentLight
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.accentLight,
                                          ),
                                        ),
                                      )
                                    : CustomIconWidget(
                                        iconName: 'refresh',
                                        color: AppTheme.accentLight,
                                        size: 16.sp,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: const [
                      Tab(text: 'Auth'),
                      Tab(text: 'Dashboard'),
                      Tab(text: 'Projects'),
                      Tab(text: 'Resume'),
                      Tab(text: 'Analytics'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ],
              ),
            ),
            // Date range selector
            SizedBox(height: 2.h),
            DateRangeSelectorWidget(
              selectedRange: _selectedDateRange,
              onRangeChanged: _onDateRangeChanged,
            ),
            SizedBox(height: 2.h),
            // Main content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAnalytics,
                color: AppTheme.accentLight,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Key metrics cards
                      SizedBox(
                        height: 20.h,
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _metricsData.length,
                          itemBuilder: (context, index) {
                            final metric = _metricsData[index];
                            return MetricsCardWidget(
                              title: metric["title"] as String,
                              value: metric["value"] as String,
                              trend: metric["trend"] as String,
                              isPositive: metric["isPositive"] as bool,
                              icon: CustomIconWidget(
                                iconName: metric["icon"] as String,
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20.sp,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 3.h),
                      // KPI Carousel
                      KpiCarouselWidget(kpiData: _kpiData),
                      SizedBox(height: 3.h),
                      // Traffic line chart
                      ChartContainerWidget(
                        title: 'Portfolio Traffic Over Time',
                        chart:
                            TrafficLineChartWidget(trafficData: _trafficData),
                        onExport: _exportAnalytics,
                        onRefresh: _refreshAnalytics,
                      ),
                      SizedBox(height: 2.h),
                      // Project popularity pie chart
                      ChartContainerWidget(
                        title: 'Project Popularity Distribution',
                        chart: ProjectPopularityPieChartWidget(
                          projectData: _projectPopularityData,
                        ),
                        onExport: _exportAnalytics,
                      ),
                      SizedBox(height: 2.h),
                      // Skill interest bar chart
                      ChartContainerWidget(
                        title: 'Skill Interest Levels',
                        chart: SkillInterestBarChartWidget(
                          skillData: _skillInterestData,
                        ),
                        onExport: _exportAnalytics,
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.textMediumEmphasisLight,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fingerprint',
              color: _currentBottomIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Auth',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentBottomIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'work',
              color: _currentBottomIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'description',
              color: _currentBottomIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Resume',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentBottomIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _currentBottomIndex == 5
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textMediumEmphasisLight,
              size: 20.sp,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
