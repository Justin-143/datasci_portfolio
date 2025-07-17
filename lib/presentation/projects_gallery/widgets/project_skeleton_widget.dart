import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProjectSkeletonWidget extends StatefulWidget {
  const ProjectSkeletonWidget({Key? key}) : super(key: key);

  @override
  State<ProjectSkeletonWidget> createState() => _ProjectSkeletonWidgetState();
}

class _ProjectSkeletonWidgetState extends State<ProjectSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton thumbnail
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: _animation.value * 0.3),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skeleton title
                    Container(
                      width: 70.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: _animation.value * 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Skeleton description lines
                    Container(
                      width: 85.w,
                      height: 1.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: _animation.value * 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Container(
                      width: 60.w,
                      height: 1.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: _animation.value * 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Skeleton tech chips
                    Row(
                      children: [
                        Container(
                          width: 15.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 20.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 12.w,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Skeleton date and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 25.w,
                          height: 1.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: 18.w,
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
