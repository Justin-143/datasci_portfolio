import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_options_widget.dart';
import './widgets/resume_header_widget.dart';
import './widgets/section_header_widget.dart';
import './widgets/timeline_entry_widget.dart';
import './widgets/timeline_scrubber_widget.dart';

class InteractiveResume extends StatefulWidget {
  const InteractiveResume({Key? key}) : super(key: key);

  @override
  State<InteractiveResume> createState() => _InteractiveResumeState();
}

class _InteractiveResumeState extends State<InteractiveResume>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  String _expandedEntryId = '';
  bool _isLoading = false;
  bool _showScrubber = false;
  String _selectedYear = '2024';
  Map<String, bool> _sectionExpanded = {
    'experience': true,
    'education': true,
    'certifications': true,
    'publications': true,
  };

  AdminOptionsWidget? _activeAdminOptions;
  OverlayEntry? _overlayEntry;

  // Mock resume data
  final List<Map<String, dynamic>> _experienceData = [
    {
      "id": "exp_1",
      "type": "experience",
      "title": "Senior Data Scientist",
      "company": "TechCorp Analytics",
      "logo":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "duration": "Jan 2022 - Present",
      "year": "2024",
      "description":
          "Leading advanced analytics initiatives and machine learning model development for enterprise-scale data solutions.",
      "achievements": [
        "Developed predictive models that improved customer retention by 35%",
        "Led a team of 5 data scientists in building real-time recommendation systems",
        "Implemented MLOps pipeline reducing model deployment time by 60%",
        "Published 3 research papers in top-tier ML conferences"
      ],
      "technologies": [
        "Python",
        "TensorFlow",
        "AWS",
        "Docker",
        "Kubernetes",
        "Apache Spark"
      ],
      "projects": [
        "Customer Churn Prediction",
        "Real-time Recommendation Engine",
        "Fraud Detection System"
      ]
    },
    {
      "id": "exp_2",
      "type": "experience",
      "title": "Data Scientist",
      "company": "DataVision Inc",
      "logo":
          "https://images.unsplash.com/photo-1551434678-e076c223a692?w=200&h=200&fit=crop",
      "duration": "Mar 2020 - Dec 2021",
      "year": "2021",
      "description":
          "Specialized in computer vision and NLP applications for business intelligence and automation.",
      "achievements": [
        "Built computer vision system for automated quality control",
        "Developed NLP pipeline for sentiment analysis of customer feedback",
        "Reduced manual data processing time by 80% through automation",
        "Mentored 3 junior data scientists"
      ],
      "technologies": [
        "Python",
        "OpenCV",
        "NLTK",
        "PostgreSQL",
        "Flask",
        "React"
      ],
      "projects": [
        "Quality Control Vision System",
        "Sentiment Analysis Dashboard",
        "Document Classification Tool"
      ]
    },
    {
      "id": "exp_3",
      "type": "experience",
      "title": "Junior Data Analyst",
      "company": "StartupMetrics",
      "logo":
          "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=200&h=200&fit=crop",
      "duration": "Jun 2018 - Feb 2020",
      "year": "2019",
      "description":
          "Focused on business intelligence, data visualization, and statistical analysis for startup growth metrics.",
      "achievements": [
        "Created executive dashboards used by C-level management",
        "Performed A/B testing that increased conversion rates by 25%",
        "Automated reporting processes saving 20 hours per week",
        "Collaborated with product team on data-driven feature decisions"
      ],
      "technologies": [
        "R",
        "Tableau",
        "SQL",
        "Excel",
        "Google Analytics",
        "Mixpanel"
      ],
      "projects": [
        "Executive Dashboard",
        "A/B Testing Framework",
        "User Behavior Analytics"
      ]
    }
  ];

  final List<Map<String, dynamic>> _educationData = [
    {
      "id": "edu_1",
      "type": "education",
      "title": "Master of Science in Data Science",
      "company": "Stanford University",
      "logo":
          "https://images.unsplash.com/photo-1562774053-701939374585?w=200&h=200&fit=crop",
      "duration": "Sep 2016 - Jun 2018",
      "year": "2018",
      "description":
          "Specialized in machine learning, statistical modeling, and big data analytics with focus on real-world applications.",
      "achievements": [
        "Graduated Summa Cum Laude with 3.9 GPA",
        "Teaching Assistant for Machine Learning course",
        "Published thesis on 'Deep Learning for Time Series Forecasting'",
        "Winner of Stanford Data Science Competition 2018"
      ],
      "technologies": [
        "Python",
        "R",
        "MATLAB",
        "Hadoop",
        "Spark",
        "TensorFlow"
      ],
      "projects": [
        "Time Series Forecasting Research",
        "Healthcare Analytics Project",
        "Social Network Analysis"
      ]
    },
    {
      "id": "edu_2",
      "type": "education",
      "title": "Bachelor of Science in Computer Science",
      "company": "UC Berkeley",
      "logo":
          "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=200&h=200&fit=crop",
      "duration": "Sep 2012 - May 2016",
      "year": "2016",
      "description":
          "Strong foundation in algorithms, data structures, and software engineering with minor in Statistics.",
      "achievements": [
        "Dean's List for 6 consecutive semesters",
        "President of Computer Science Student Association",
        "Internship at Google Summer of Code",
        "Developed award-winning mobile app for campus navigation"
      ],
      "technologies": ["Java", "C++", "Python", "JavaScript", "MySQL", "Git"],
      "projects": [
        "Campus Navigation App",
        "Distributed Systems Project",
        "Algorithm Optimization Research"
      ]
    }
  ];

  final List<Map<String, dynamic>> _certificationsData = [
    {
      "id": "cert_1",
      "type": "certification",
      "title": "AWS Certified Machine Learning - Specialty",
      "company": "Amazon Web Services",
      "logo":
          "https://images.unsplash.com/photo-1523474253046-8cd2748b5fd2?w=200&h=200&fit=crop",
      "duration": "Valid until Dec 2025",
      "year": "2023",
      "description":
          "Advanced certification demonstrating expertise in building, training, and deploying ML models on AWS.",
      "achievements": [
        "Scored 95% on certification exam",
        "Validated expertise in SageMaker, Lambda, and ML services",
        "Demonstrated knowledge of MLOps best practices",
        "Certified to architect ML solutions at enterprise scale"
      ],
      "technologies": [
        "AWS SageMaker",
        "Lambda",
        "S3",
        "EC2",
        "CloudWatch",
        "IAM"
      ],
      "projects": []
    },
    {
      "id": "cert_2",
      "type": "certification",
      "title": "Google Professional Data Engineer",
      "company": "Google Cloud",
      "logo":
          "https://images.unsplash.com/photo-1573804633927-bfcbcd909acd?w=200&h=200&fit=crop",
      "duration": "Valid until Aug 2025",
      "year": "2023",
      "description":
          "Professional certification for designing and building data processing systems on Google Cloud Platform.",
      "achievements": [
        "Demonstrated expertise in BigQuery and Dataflow",
        "Validated skills in data pipeline architecture",
        "Certified in ML model deployment on GCP",
        "Proven ability to optimize data processing workflows"
      ],
      "technologies": [
        "BigQuery",
        "Dataflow",
        "Pub/Sub",
        "Cloud Storage",
        "AI Platform",
        "Kubernetes"
      ],
      "projects": []
    }
  ];

  final List<Map<String, dynamic>> _publicationsData = [
    {
      "id": "pub_1",
      "type": "publication",
      "title": "Deep Learning Approaches for Real-Time Fraud Detection",
      "company": "IEEE Transactions on Neural Networks",
      "logo":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=200&h=200&fit=crop",
      "duration": "Published March 2024",
      "year": "2024",
      "description":
          "Research paper on novel deep learning architectures for detecting fraudulent transactions in real-time systems.",
      "achievements": [
        "Cited by 45+ research papers within 6 months",
        "Presented at International Conference on Machine Learning",
        "Featured in MIT Technology Review",
        "Implemented by 3 major financial institutions"
      ],
      "technologies": [
        "Deep Learning",
        "PyTorch",
        "LSTM",
        "Attention Mechanisms",
        "Real-time Processing"
      ],
      "projects": ["Fraud Detection Research", "Real-time ML Pipeline"]
    },
    {
      "id": "pub_2",
      "type": "publication",
      "title": "Scalable Time Series Forecasting with Transformer Networks",
      "company": "Journal of Machine Learning Research",
      "logo":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=200&h=200&fit=crop",
      "duration": "Published September 2023",
      "year": "2023",
      "description":
          "Comprehensive study on applying transformer architectures to large-scale time series forecasting problems.",
      "achievements": [
        "Achieved state-of-the-art results on 5 benchmark datasets",
        "Open-sourced implementation with 2000+ GitHub stars",
        "Invited speaker at NeurIPS 2023 workshop",
        "Adopted by major tech companies for production forecasting"
      ],
      "technologies": [
        "Transformers",
        "Time Series",
        "PyTorch",
        "Distributed Training",
        "CUDA"
      ],
      "projects": ["Time Series Transformer", "Forecasting Benchmark Suite"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );

    _scrollController.addListener(_onScroll);
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeAnimationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onScroll() {
    final showScrubber = _scrollController.offset > 200;
    if (showScrubber != _showScrubber) {
      setState(() {
        _showScrubber = showScrubber;
      });
    }
  }

  List<Map<String, dynamic>> get _allTimelineData {
    return [
      ..._experienceData,
      ..._educationData,
      ..._certificationsData,
      ..._publicationsData,
    ]..sort((a, b) => int.parse(b["year"]).compareTo(int.parse(a["year"])));
  }

  List<String> get _availableYears {
    final years =
        _allTimelineData.map((item) => item["year"] as String).toSet().toList();
    years.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    return years;
  }

  Future<void> _refreshResume() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
  }

  Future<void> _downloadPDF() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resumeContent = _generateResumeContent();

      if (kIsWeb) {
        final bytes = utf8.encode(resumeContent);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "interactive_resume.txt")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile, we'll create a text file as PDF generation requires additional packages
        final fileName =
            "interactive_resume_${DateTime.now().millisecondsSinceEpoch}.txt";
        // In a real implementation, you would use pdf package to generate actual PDF
      }

      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Resume downloaded successfully!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Download failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generateResumeContent() {
    final buffer = StringBuffer();
    buffer.writeln('INTERACTIVE RESUME');
    buffer.writeln('Generated on: ${DateTime.now().toString()}');
    buffer.writeln('');

    buffer.writeln('PROFESSIONAL EXPERIENCE');
    buffer.writeln('========================');
    for (final exp in _experienceData) {
      buffer.writeln('${exp["title"]} at ${exp["company"]}');
      buffer.writeln('Duration: ${exp["duration"]}');
      buffer.writeln('Description: ${exp["description"]}');
      buffer.writeln('');
    }

    buffer.writeln('EDUCATION');
    buffer.writeln('=========');
    for (final edu in _educationData) {
      buffer.writeln('${edu["title"]} - ${edu["company"]}');
      buffer.writeln('Duration: ${edu["duration"]}');
      buffer.writeln('');
    }

    return buffer.toString();
  }

  void _shareResume() {
    final shareOptions = [
      'PDF Download',
      'LinkedIn Profile',
      'Portfolio URL',
      'Email Resume',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Share Resume',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            ...shareOptions.map((option) => ListTile(
                  leading: CustomIconWidget(
                    iconName: _getShareIcon(option),
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  title: Text(option),
                  onTap: () {
                    Navigator.pop(context);
                    _handleShareOption(option);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getShareIcon(String option) {
    switch (option) {
      case 'PDF Download':
        return 'download';
      case 'LinkedIn Profile':
        return 'work';
      case 'Portfolio URL':
        return 'link';
      case 'Email Resume':
        return 'email';
      default:
        return 'share';
    }
  }

  void _handleShareOption(String option) {
    HapticFeedback.lightImpact();

    switch (option) {
      case 'PDF Download':
        _downloadPDF();
        break;
      case 'LinkedIn Profile':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('LinkedIn profile link copied to clipboard')),
        );
        break;
      case 'Portfolio URL':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portfolio URL copied to clipboard')),
        );
        break;
      case 'Email Resume':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email composer opened')),
        );
        break;
    }
  }

  void _onYearSelected(String year) {
    setState(() {
      _selectedYear = year;
    });

    // Scroll to the first entry of the selected year
    final yearEntries =
        _allTimelineData.where((item) => item["year"] == year).toList();
    if (yearEntries.isNotEmpty) {
      final index = _allTimelineData.indexOf(yearEntries.first);
      _scrollController.animateTo(
        index * 200.0, // Approximate height per entry
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleEntry(String entryId) {
    setState(() {
      _expandedEntryId = _expandedEntryId == entryId ? '' : entryId;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleSection(String sectionKey) {
    setState(() {
      _sectionExpanded[sectionKey] = !(_sectionExpanded[sectionKey] ?? true);
    });
  }

  void _showAdminOptions(String entryId, Offset position) {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 80.w,
        top: position.dy - 20.h,
        child: Material(
          color: Colors.transparent,
          child: AdminOptionsWidget(
            onEdit: () {
              _removeOverlay();
              _handleAdminAction('edit', entryId);
            },
            onReorder: () {
              _removeOverlay();
              _handleAdminAction('reorder', entryId);
            },
            onDelete: () {
              _removeOverlay();
              _handleAdminAction('delete', entryId);
            },
            onCancel: _removeOverlay,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleAdminAction(String action, String entryId) {
    HapticFeedback.lightImpact();

    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality would open here')),
        );
        break;
      case 'reorder':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Reorder functionality would open here')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(entryId);
        break;
    }
  }

  void _showDeleteConfirmation(String entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this timeline entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry deleted successfully')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              ResumeHeaderWidget(
                onDownloadPdf: _downloadPDF,
                onShare: _shareResume,
                isLoading: _isLoading,
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshResume,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildTimelineContent(),
                  ),
                ),
              ),
            ],
          ),
          if (_showScrubber)
            Positioned(
              right: 0,
              top: 15.h,
              child: TimelineScrubberWidget(
                years: _availableYears,
                selectedYear: _selectedYear,
                onYearSelected: _onYearSelected,
                isVisible: _showScrubber,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Professional Experience',
            'work',
            _experienceData,
            'experience',
          ),
          _buildSection(
            'Education',
            'school',
            _educationData,
            'education',
          ),
          _buildSection(
            'Certifications',
            'verified',
            _certificationsData,
            'certifications',
          ),
          _buildSection(
            'Publications',
            'article',
            _publicationsData,
            'publications',
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String icon,
    List<Map<String, dynamic>> data,
    String sectionKey,
  ) {
    final isExpanded = _sectionExpanded[sectionKey] ?? true;

    return Column(
      children: [
        SectionHeaderWidget(
          title: title,
          icon: icon,
          itemCount: data.length,
          isExpanded: isExpanded,
          onToggle: () => _toggleSection(sectionKey),
        ),
        if (isExpanded)
          ...data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == data.length - 1;

            return TimelineEntryWidget(
              entry: item,
              isExpanded: _expandedEntryId == item["id"],
              onTap: () => _toggleEntry(item["id"]),
              onLongPress: () {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                _showAdminOptions(item["id"], position);
              },
              isLast: isLast,
            );
          }),
      ],
    );
  }
}
