import 'package:flutter/material.dart';
import '../presentation/biometric_authentication/biometric_authentication.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/projects_gallery/projects_gallery.dart';
import '../presentation/settings/settings.dart';
import '../presentation/portfolio_dashboard/portfolio_dashboard.dart';
import '../presentation/interactive_resume/interactive_resume.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String biometricAuthentication = '/biometric-authentication';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String projectsGallery = '/projects-gallery';
  static const String settings = '/settings';
  static const String portfolioDashboard = '/portfolio-dashboard';
  static const String interactiveResume = '/interactive-resume';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => PortfolioDashboard(),
    biometricAuthentication: (context) => BiometricAuthentication(),
    analyticsDashboard: (context) => AnalyticsDashboard(),
    projectsGallery: (context) => ProjectsGallery(),
    settings: (context) => Settings(),
    portfolioDashboard: (context) => PortfolioDashboard(),
    interactiveResume: (context) => InteractiveResume(),
    // TODO: Add your other routes here
  };
}
