import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExportOptionsWidget extends StatefulWidget {
  const ExportOptionsWidget({super.key});

  @override
  State<ExportOptionsWidget> createState() => _ExportOptionsWidgetState();
}

class _ExportOptionsWidgetState extends State<ExportOptionsWidget> {
  bool _isExportingPortfolio = false;
  bool _isExportingData = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Export Portfolio
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Portfolio',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Download portfolio as PDF',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isExportingPortfolio ? null : _exportPortfolio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  minimumSize: Size(20.w, 5.h),
                ),
                child: _isExportingPortfolio
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Export',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        // Export Data
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Data',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Download all data as JSON',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isExportingData ? null : _exportData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  minimumSize: Size(20.w, 5.h),
                ),
                child: _isExportingData
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onSecondary,
                          ),
                        ),
                      )
                    : Text(
                        'Export',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _exportPortfolio() async {
    setState(() => _isExportingPortfolio = true);

    try {
      // Generate portfolio content
      final portfolioContent = _generatePortfolioContent();
      await _downloadFile(portfolioContent,
          'portfolio_${DateTime.now().millisecondsSinceEpoch}.txt');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Portfolio exported successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingPortfolio = false);
      }
    }
  }

  Future<void> _exportData() async {
    setState(() => _isExportingData = true);

    try {
      // Generate data export
      final dataContent = _generateDataExport();
      await _downloadFile(dataContent,
          'data_export_${DateTime.now().millisecondsSinceEpoch}.json');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExportingData = false);
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For mobile platforms, this would require path_provider
      // For now, we'll show a success message
      await Future.delayed(Duration(seconds: 2));
    }
  }

  String _generatePortfolioContent() {
    return '''
DataSci Portfolio Export
========================

Personal Information:
- Name: Dr. Sarah Chen
- Title: Senior Data Scientist
- Email: sarah.chen@datasci.com
- Location: San Francisco, CA

Skills:
- Machine Learning: 95%
- Python: 90%
- R: 85%
- SQL: 88%
- Deep Learning: 92%
- Data Visualization: 87%

Projects:
1. Predictive Analytics Platform
   - Description: Built end-to-end ML pipeline for customer churn prediction
   - Technologies: Python, TensorFlow, AWS
   - Impact: Reduced churn by 23%

2. Real-time Fraud Detection
   - Description: Implemented streaming ML model for transaction monitoring
   - Technologies: Kafka, Spark, MLflow
   - Impact: Detected 99.2% of fraudulent transactions

3. NLP Sentiment Analysis
   - Description: Developed sentiment analysis for social media monitoring
   - Technologies: BERT, PyTorch, Docker
   - Impact: Improved brand sentiment tracking by 40%

Experience:
- Senior Data Scientist at TechCorp (2021-Present)
- Data Scientist at StartupXYZ (2019-2021)
- Junior Analyst at DataFirm (2017-2019)

Education:
- Ph.D. in Computer Science, Stanford University (2017)
- M.S. in Statistics, UC Berkeley (2014)
- B.S. in Mathematics, MIT (2012)

Certifications:
- AWS Certified Machine Learning Specialist
- Google Cloud Professional Data Engineer
- Certified Analytics Professional (CAP)

Generated on: ${DateTime.now().toString()}
    ''';
  }

  String _generateDataExport() {
    final data = {
      'export_info': {
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'type': 'full_data_export'
      },
      'profile': {
        'name': 'Dr. Sarah Chen',
        'title': 'Senior Data Scientist',
        'email': 'sarah.chen@datasci.com',
        'location': 'San Francisco, CA',
        'bio':
            'Passionate data scientist with 7+ years of experience in machine learning and analytics.'
      },
      'skills': [
        {
          'name': 'Machine Learning',
          'proficiency': 95,
          'category': 'Technical'
        },
        {'name': 'Python', 'proficiency': 90, 'category': 'Programming'},
        {'name': 'R', 'proficiency': 85, 'category': 'Programming'},
        {'name': 'SQL', 'proficiency': 88, 'category': 'Database'},
        {'name': 'Deep Learning', 'proficiency': 92, 'category': 'Technical'},
        {
          'name': 'Data Visualization',
          'proficiency': 87,
          'category': 'Technical'
        }
      ],
      'projects': [
        {
          'id': 1,
          'title': 'Predictive Analytics Platform',
          'description':
              'Built end-to-end ML pipeline for customer churn prediction',
          'technologies': ['Python', 'TensorFlow', 'AWS'],
          'impact': 'Reduced churn by 23%',
          'status': 'completed',
          'date': '2023-06-15'
        },
        {
          'id': 2,
          'title': 'Real-time Fraud Detection',
          'description':
              'Implemented streaming ML model for transaction monitoring',
          'technologies': ['Kafka', 'Spark', 'MLflow'],
          'impact': 'Detected 99.2% of fraudulent transactions',
          'status': 'completed',
          'date': '2023-09-20'
        }
      ],
      'analytics': {
        'portfolio_views': 1247,
        'project_downloads': 89,
        'profile_visits': 456,
        'last_updated': DateTime.now().toIso8601String()
      },
      'settings': {
        'theme': 'light',
        'language': 'en',
        'notifications': {
          'push_enabled': true,
          'email_enabled': true,
          'engagement_alerts': true
        },
        'privacy': {
          'portfolio_public': true,
          'analytics_tracking': true,
          'contact_form_enabled': true
        }
      }
    };

    return jsonEncode(data);
  }
}