import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentProjectsCarousel extends StatefulWidget {
  const RecentProjectsCarousel({super.key});

  @override
  State<RecentProjectsCarousel> createState() => _RecentProjectsCarouselState();
}

class _RecentProjectsCarouselState extends State<RecentProjectsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  final List<Map<String, dynamic>> recentProjects = [
    {
      "id": 1,
      "title": "Customer Churn Prediction",
      "description":
          "ML model predicting customer churn with 94% accuracy using ensemble methods",
      "image":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000",
      "category": "Machine Learning",
      "status": "Completed",
      "date": "2025-01-15",
      "technologies": ["Python", "Scikit-learn", "Pandas"],
    },
    {
      "id": 2,
      "title": "Sales Forecasting Dashboard",
      "description":
          "Interactive dashboard for sales forecasting with real-time data visualization",
      "image":
          "https://images.pexels.com/photos/590022/pexels-photo-590022.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Data Visualization",
      "status": "In Progress",
      "date": "2025-01-10",
      "technologies": ["Tableau", "SQL", "Python"],
    },
    {
      "id": 3,
      "title": "NLP Sentiment Analysis",
      "description":
          "Advanced sentiment analysis system for social media monitoring",
      "image":
          "https://cdn.pixabay.com/photo/2018/05/08/08/44/artificial-intelligence-3382507_1280.jpg",
      "category": "Natural Language Processing",
      "status": "Completed",
      "date": "2025-01-05",
      "technologies": ["BERT", "TensorFlow", "Docker"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/projects-gallery');
                  },
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 28.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: recentProjects.length,
              itemBuilder: (context, index) {
                return _buildProjectCard(recentProjects[index], index);
              },
            ),
          ),
          SizedBox(height: 2.h),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, int index) {
    bool isActive = index == _currentIndex;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      transform: Matrix4.identity()..scale(isActive ? 1.0 : 0.95),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/projects-gallery');
        },
        child: Hero(
          tag: 'project_${project["id"]}',
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: isActive ? 0.15 : 0.08),
                  blurRadius: isActive ? 12 : 8,
                  offset: Offset(0, isActive ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: CustomImageWidget(
                      imageUrl: project["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    _getStatusColor(project["status"] as String)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                project["status"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _getStatusColor(
                                      project["status"] as String),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              project["date"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          project["title"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          project["description"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Wrap(
                          spacing: 1.w,
                          children: (project["technologies"] as List<String>)
                              .take(2)
                              .map((tech) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tech,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontSize: 10.sp,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        recentProjects.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: index == _currentIndex ? 6.w : 2.w,
          height: 1.h,
          decoration: BoxDecoration(
            color: index == _currentIndex
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Color(0xFF38A169);
      case 'In Progress':
        return Color(0xFFD69E2E);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
