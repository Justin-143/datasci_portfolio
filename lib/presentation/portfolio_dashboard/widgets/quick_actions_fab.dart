import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsFab extends StatefulWidget {
  const QuickActionsFab({super.key});

  @override
  State<QuickActionsFab> createState() => _QuickActionsFabState();
}

class _QuickActionsFabState extends State<QuickActionsFab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "Add Project",
      "icon": "add",
      "color": Color(0xFF38A169),
      "route": "/projects-gallery",
    },
    {
      "title": "Update Skills",
      "icon": "psychology",
      "color": Color(0xFF3182CE),
      "route": "/settings",
    },
    {
      "title": "Share Portfolio",
      "icon": "share",
      "color": Color(0xFFD69E2E),
      "route": "/analytics-dashboard",
    },
    {
      "title": "Analytics",
      "icon": "analytics",
      "color": Color(0xFF9F7AEA),
      "route": "/analytics-dashboard",
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
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isExpanded) _buildOverlay(),
        ..._buildActionButtons(),
        _buildMainFab(),
      ],
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    return quickActions.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> action = entry.value;

      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double offset = (index + 1) * 15.h * _animation.value;

          return Positioned(
            bottom: offset,
            right: 0,
            child: Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: _buildActionButton(action),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildActionButton(Map<String, dynamic> action) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h, right: 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              action["title"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              _handleActionTap(action);
            },
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: action["color"] as Color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (action["color"] as Color).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: action["icon"] as String,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFab() {
    return FloatingActionButton(
      onPressed: _toggleExpanded,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      child: AnimatedRotation(
        turns: _isExpanded ? 0.125 : 0,
        duration: Duration(milliseconds: 300),
        child: CustomIconWidget(
          iconName: _isExpanded ? 'close' : 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleActionTap(Map<String, dynamic> action) {
    _toggleExpanded();

    // Add haptic feedback
    // HapticFeedback.lightImpact();

    // Navigate to the specified route
    Navigator.pushNamed(context, action["route"] as String);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
