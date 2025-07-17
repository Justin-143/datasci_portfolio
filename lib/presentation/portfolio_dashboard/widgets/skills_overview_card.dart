import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillsOverviewCard extends StatefulWidget {
  const SkillsOverviewCard({super.key});

  @override
  State<SkillsOverviewCard> createState() => _SkillsOverviewCardState();
}

class _SkillsOverviewCardState extends State<SkillsOverviewCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> topSkills = [
    {
      "skill": "Python",
      "proficiency": 95,
      "color": Color(0xFF3776AB),
      "icon": "code",
    },
    {
      "skill": "Machine Learning",
      "proficiency": 90,
      "color": Color(0xFF38A169),
      "icon": "psychology",
    },
    {
      "skill": "Data Visualization",
      "proficiency": 88,
      "color": Color(0xFF3182CE),
      "icon": "bar_chart",
    },
    {
      "skill": "SQL",
      "proficiency": 85,
      "color": Color(0xFFD69E2E),
      "icon": "storage",
    },
    {
      "skill": "Deep Learning",
      "proficiency": 82,
      "color": Color(0xFF9F7AEA),
      "icon": "memory",
    },
    {
      "skill": "Statistics",
      "proficiency": 80,
      "color": Color(0xFFE53E3E),
      "icon": "functions",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

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
                  'Skills Overview',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                          _isExpanded
                              ? _animationController.forward()
                              : _animationController.reverse();
                        });
                      },
                      child: Text(
                        _isExpanded ? 'Show Less' : 'Show All',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildSkillsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsList() {
    List<Map<String, dynamic>> displayedSkills =
        _isExpanded ? topSkills : topSkills.take(3).toList();

    return Column(
      children: [
        ...displayedSkills.map((skill) => _buildSkillItem(skill)).toList(),
        if (!_isExpanded && topSkills.length > 3)
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              children: topSkills
                  .skip(3)
                  .map((skill) => _buildSkillItem(skill))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (skill["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: skill["icon"] as String,
                      color: skill["color"] as Color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    skill["skill"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${skill["proficiency"]}%',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: skill["color"] as Color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildAnimatedProgressBar(skill),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgressBar(Map<String, dynamic> skill) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: (skill["proficiency"] as int) / 100,
      ),
      builder: (context, value, _) {
        return Column(
          children: [
            Container(
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        skill["color"] as Color,
                        (skill["color"] as Color).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: (skill["color"] as Color).withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
