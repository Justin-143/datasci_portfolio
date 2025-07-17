import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/project_card_widget.dart';
import './widgets/project_skeleton_widget.dart';
import './widgets/search_bar_widget.dart';

class ProjectsGallery extends StatefulWidget {
  const ProjectsGallery({Key? key}) : super(key: key);

  @override
  State<ProjectsGallery> createState() => _ProjectsGalleryState();
}

class _ProjectsGalleryState extends State<ProjectsGallery>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  Map<String, List<String>> _selectedFilters = {};
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _filteredProjects = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Mock data for projects
  final List<Map<String, dynamic>> _mockProjects = [
    {
      "id": 1,
      "title": "Customer Churn Prediction Model",
      "description":
          "Machine learning model to predict customer churn using advanced analytics and behavioral data patterns.",
      "thumbnail":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "Scikit-learn", "Pandas", "SQL"],
      "completionDate": "Dec 2024",
      "status": "Completed",
      "industry": "Finance",
      "complexity": "Advanced",
      "duration": "3-6 months"
    },
    {
      "id": 2,
      "title": "Sales Forecasting Dashboard",
      "description":
          "Interactive dashboard for sales forecasting using time series analysis and predictive modeling techniques.",
      "thumbnail":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=3000",
      "techStack": ["R", "Shiny", "ggplot2", "Prophet"],
      "completionDate": "Nov 2024",
      "status": "Completed",
      "industry": "E-commerce",
      "complexity": "Intermediate",
      "duration": "1-3 months"
    },
    {
      "id": 3,
      "title": "Healthcare Data Analysis",
      "description":
          "Comprehensive analysis of patient data to identify treatment patterns and improve healthcare outcomes.",
      "thumbnail":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "TensorFlow", "NumPy", "Matplotlib"],
      "completionDate": "Jan 2025",
      "status": "In Progress",
      "industry": "Healthcare",
      "complexity": "Expert",
      "duration": "> 6 months"
    },
    {
      "id": 4,
      "title": "Sentiment Analysis Tool",
      "description":
          "Natural language processing tool for analyzing customer sentiment from social media and reviews.",
      "thumbnail":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "NLTK", "PyTorch", "Docker"],
      "completionDate": "Oct 2024",
      "status": "Completed",
      "industry": "Entertainment",
      "complexity": "Advanced",
      "duration": "1-3 months"
    },
    {
      "id": 5,
      "title": "Supply Chain Optimization",
      "description":
          "Optimization model for supply chain management using linear programming and simulation techniques.",
      "thumbnail":
          "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "Pandas", "Jupyter", "SQL"],
      "completionDate": "Mar 2025",
      "status": "Planned",
      "industry": "Manufacturing",
      "complexity": "Intermediate",
      "duration": "3-6 months"
    },
    {
      "id": 6,
      "title": "Fraud Detection System",
      "description":
          "Real-time fraud detection system using machine learning algorithms and anomaly detection techniques.",
      "thumbnail":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "Scikit-learn", "TensorFlow", "Docker"],
      "completionDate": "Sep 2024",
      "status": "Completed",
      "industry": "Finance",
      "complexity": "Expert",
      "duration": "> 6 months"
    },
    {
      "id": 7,
      "title": "Energy Consumption Predictor",
      "description":
          "Predictive model for energy consumption patterns using IoT sensor data and time series analysis.",
      "thumbnail":
          "https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?fm=jpg&q=60&w=3000",
      "techStack": ["R", "Prophet", "ggplot2", "SQL"],
      "completionDate": "Feb 2025",
      "status": "In Progress",
      "industry": "Energy",
      "complexity": "Advanced",
      "duration": "3-6 months"
    },
    {
      "id": 8,
      "title": "Recommendation Engine",
      "description":
          "Collaborative filtering recommendation system for e-commerce platform using matrix factorization.",
      "thumbnail":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000",
      "techStack": ["Python", "Pandas", "NumPy", "Jupyter"],
      "completionDate": "Aug 2024",
      "status": "Completed",
      "industry": "E-commerce",
      "complexity": "Intermediate",
      "duration": "1-3 months"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 2);
    _scrollController.addListener(_onScroll);
    _loadProjects();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProjects();
    }
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _projects = _mockProjects.take(_itemsPerPage).toList();
      _filteredProjects = List.from(_projects);
      _isLoading = false;
    });
  }

  Future<void> _loadMoreProjects() async {
    if (_isLoadingMore || _projects.length >= _mockProjects.length) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      final startIndex = _currentPage * _itemsPerPage;
      final endIndex =
          (startIndex + _itemsPerPage).clamp(0, _mockProjects.length);
      _projects.addAll(_mockProjects.sublist(startIndex, endIndex));
      _applyFilters();
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshProjects() async {
    setState(() {
      _currentPage = 1;
      _projects.clear();
      _filteredProjects.clear();
    });
    await _loadProjects();
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_projects);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((project) {
        return (project['title'] as String).toLowerCase().contains(query) ||
            (project['description'] as String).toLowerCase().contains(query) ||
            (project['techStack'] as List)
                .any((tech) => (tech as String).toLowerCase().contains(query));
      }).toList();
    }

    // Apply category filters
    _selectedFilters.forEach((category, values) {
      if (values.isNotEmpty) {
        filtered = filtered.where((project) {
          switch (category) {
            case 'Technology':
              return (project['techStack'] as List)
                  .any((tech) => values.contains(tech));
            case 'Industry':
              return values.contains(project['industry']);
            case 'Complexity':
              return values.contains(project['complexity']);
            case 'Status':
              return values.contains(project['status']);
            case 'Duration':
              return values.contains(project['duration']);
            default:
              return true;
          }
        }).toList();
      }
    });

    setState(() {
      _filteredProjects = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilters: _selectedFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _selectedFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showProjectActions(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Project'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Bookmark'),
              onTap: () {
                Navigator.pop(context);
                // Implement bookmark functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit Project'),
              onTap: () {
                Navigator.pop(context);
                // Implement edit functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getActiveFilterLabels() {
    List<String> labels = [];
    _selectedFilters.forEach((category, values) {
      labels.addAll(values);
    });
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('DataSci Portfolio'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Biometric'),
            Tab(text: 'Dashboard'),
            Tab(text: 'Projects'),
            Tab(text: 'Resume'),
            Tab(text: 'Analytics'),
            Tab(text: 'Settings'),
          ],
          onTap: (index) {
            final routes = [
              '/biometric-authentication',
              '/portfolio-dashboard',
              '/projects-gallery',
              '/interactive-resume',
              '/analytics-dashboard',
              '/settings'
            ];
            if (index != 2) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchBarWidget(
              controller: _searchController,
              onFilterTap: _showFilterBottomSheet,
              onChanged: (value) => _applyFilters(),
              onClear: () {
                _searchController.clear();
                _applyFilters();
              },
            ),

            // Active filters
            if (_getActiveFilterLabels().isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _getActiveFilterLabels().length,
                  itemBuilder: (context, index) {
                    final label = _getActiveFilterLabels()[index];
                    return FilterChipWidget(
                      label: label,
                      isSelected: true,
                      onTap: () {},
                      onRemove: () {
                        // Remove filter logic
                        _selectedFilters.forEach((category, values) {
                          if (values.contains(label)) {
                            values.remove(label);
                            if (values.isEmpty) {
                              _selectedFilters.remove(category);
                            }
                          }
                        });
                        _applyFilters();
                      },
                    );
                  },
                ),
              ),

            // Main content
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) => ProjectSkeletonWidget(),
                    )
                  : _filteredProjects.isEmpty
                      ? EmptyStateWidget(
                          onCreateProject: () {
                            // Navigate to create project screen
                          },
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshProjects,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            itemCount: _filteredProjects.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _filteredProjects.length) {
                                return Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                    ),
                                  ),
                                );
                              }

                              final project = _filteredProjects[index];
                              return ProjectCardWidget(
                                project: project,
                                onTap: () {
                                  // Navigate to project detail with hero animation
                                  Navigator.pushNamed(
                                    context,
                                    '/project-detail',
                                    arguments: project,
                                  );
                                },
                                onLongPress: () => _showProjectActions(project),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open full-screen search
          showSearch(
            context: context,
            delegate: ProjectSearchDelegate(_mockProjects),
          );
        },
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 24,
        ),
      ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final List<Map<String, dynamic>> projects;

  ProjectSearchDelegate(this.projects);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = projects.where((project) {
      return (project['title'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          (project['description'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          (project['techStack'] as List).any((tech) =>
              (tech as String).toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final project = results[index];
        return ProjectCardWidget(
          project: project,
          onTap: () {
            close(context, project);
          },
        );
      },
    );
  }
}
