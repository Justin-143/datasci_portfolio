import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_section.dart';
import './widgets/portfolio_analytics_card.dart';
import './widgets/profile_header.dart';
import './widgets/quick_actions_fab.dart';
import './widgets/recent_projects_carousel.dart';
import './widgets/skills_overview_card.dart';

class PortfolioDashboard extends StatefulWidget {
  const PortfolioDashboard({super.key});

  @override
  State<PortfolioDashboard> createState() => _PortfolioDashboardState();
}

class _PortfolioDashboardState extends State<PortfolioDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  final List<Map<String, dynamic>> bottomNavItems = [
    {
      "icon": "dashboard",
      "label": "Dashboard",
      "route": "/portfolio-dashboard",
    },
    {
      "icon": "work",
      "label": "Projects",
      "route": "/projects-gallery",
    },
    {
      "icon": "psychology",
      "label": "Skills",
      "route": "/settings",
    },
    {
      "icon": "person",
      "label": "Profile",
      "route": "/interactive-resume",
    },
    {
      "icon": "more_horiz",
      "label": "More",
      "route": "/settings",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          ProfileHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.lightTheme.colorScheme.primary,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _refreshAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -20 * _refreshAnimation.value),
                          child: Opacity(
                            opacity: 1.0 - (_refreshAnimation.value * 0.3),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          PortfolioAnalyticsCard(),
                          SizedBox(height: 1.h),
                          RecentProjectsCarousel(),
                          SizedBox(height: 1.h),
                          SkillsOverviewCard(),
                          SizedBox(height: 1.h),
                          AchievementBadgesSection(),
                          SizedBox(height: 10.h), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: QuickActionsFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomNavItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isSelected = index == _currentIndex;

              return GestureDetector(
                onTap: () => _onBottomNavTap(index, item["route"] as String),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 4.w : 2.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: item["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: isSelected ? 26 : 24,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        item["label"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: isSelected ? 11.sp : 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index, String route) {
    setState(() {
      _currentIndex = index;
    });

    if (index != 0) {
      // Don't navigate if already on dashboard
      Navigator.pushNamed(context, route);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshAnimationController.forward();

    // Simulate refresh delay
    await Future.delayed(Duration(milliseconds: 1500));

    _refreshAnimationController.reverse();

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }
}
