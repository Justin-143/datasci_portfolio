import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/data_usage_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/notification_toggle_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_selector_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Settings state variables
  String _currentTheme = 'light';
  String _currentLanguage = 'en';
  bool _biometricEnabled = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _engagementAlerts = false;
  bool _portfolioPublic = true;
  bool _analyticsTracking = true;
  bool _contactFormEnabled = true;
  bool _isClearing = false;
  bool _isSyncing = false;
  double _cacheSize = 24.7;
  DateTime _lastSyncTime = DateTime.now().subtract(Duration(hours: 2));

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    _buildAccountSection(),
                    _buildAppearanceSection(),
                    _buildPrivacySection(),
                    _buildNotificationSection(),
                    _buildDataManagementSection(),
                    _buildExportSection(),
                    _buildAboutSection(),
                    SizedBox(height: 4.h),
                    _buildResetButton(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        'Settings',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        onChanged: (value) =>
            setState(() => _searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search settings...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['account', 'profile', 'password', 'biometric'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Account',
      children: [
        SettingsItemWidget(
          title: 'Profile Management',
          subtitle: 'Edit personal information and bio',
          iconName: 'person',
          onTap: () => _navigateToRoute('/portfolio-dashboard'),
        ),
        SettingsItemWidget(
          title: 'Change Password',
          subtitle: 'Update your account password',
          iconName: 'lock',
          onTap: () => _showPasswordDialog(),
        ),
        SettingsItemWidget(
          title: 'Biometric Authentication',
          subtitle: _biometricEnabled ? 'Enabled' : 'Disabled',
          iconName: 'fingerprint',
          trailing: Switch(
            value: _biometricEnabled,
            onChanged: (value) => setState(() => _biometricEnabled = value),
          ),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['appearance', 'theme', 'language', 'accessibility'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Appearance',
      children: [
        ThemeSelectorWidget(
          currentTheme: _currentTheme,
          onThemeChanged: (theme) => setState(() => _currentTheme = theme),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        LanguageSelectorWidget(
          currentLanguage: _currentLanguage,
          onLanguageChanged: (language) =>
              setState(() => _currentLanguage = language),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        SettingsItemWidget(
          title: 'Accessibility',
          subtitle: 'Font size, contrast, and more',
          iconName: 'accessibility',
          onTap: () => _showAccessibilityOptions(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['privacy', 'portfolio', 'analytics', 'contact'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Privacy',
      children: [
        SettingsItemWidget(
          title: 'Portfolio Visibility',
          subtitle: _portfolioPublic ? 'Public' : 'Private',
          iconName: _portfolioPublic ? 'public' : 'lock',
          trailing: Switch(
            value: _portfolioPublic,
            onChanged: (value) => setState(() => _portfolioPublic = value),
          ),
        ),
        SettingsItemWidget(
          title: 'Analytics Tracking',
          subtitle: _analyticsTracking ? 'Enabled' : 'Disabled',
          iconName: 'analytics',
          trailing: Switch(
            value: _analyticsTracking,
            onChanged: (value) => setState(() => _analyticsTracking = value),
          ),
        ),
        SettingsItemWidget(
          title: 'Contact Form',
          subtitle: _contactFormEnabled ? 'Available' : 'Disabled',
          iconName: 'contact_mail',
          trailing: Switch(
            value: _contactFormEnabled,
            onChanged: (value) => setState(() => _contactFormEnabled = value),
          ),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['notification', 'push', 'email', 'alerts'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Notifications',
      children: [
        NotificationToggleWidget(
          title: 'Push Notifications',
          subtitle: 'Receive app notifications',
          iconName: 'notifications',
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        NotificationToggleWidget(
          title: 'Email Updates',
          subtitle: 'Get updates via email',
          iconName: 'email',
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        NotificationToggleWidget(
          title: 'Engagement Alerts',
          subtitle: 'Portfolio views and interactions',
          iconName: 'trending_up',
          value: _engagementAlerts,
          onChanged: (value) => setState(() => _engagementAlerts = value),
        ),
      ],
    );
  }

  Widget _buildDataManagementSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['data', 'cache', 'sync', 'storage'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Data Management',
      children: [
        DataUsageWidget(
          cacheSize: _cacheSize,
          isClearing: _isClearing,
          onClearCache: _clearCache,
          onManualSync: _manualSync,
          isSyncing: _isSyncing,
          lastSyncTime: _lastSyncTime,
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          indent: 15.w,
        ),
        SettingsItemWidget(
          title: 'Offline Content',
          subtitle: 'Manage downloaded content',
          iconName: 'offline_pin',
          onTap: () => _showOfflineContentDialog(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildExportSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['export', 'backup', 'download'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'Export & Backup',
      children: [
        const ExportOptionsWidget(),
      ],
    );
  }

  Widget _buildAboutSection() {
    if (_searchQuery.isNotEmpty &&
        !_matchesSearch(['about', 'version', 'privacy', 'terms', 'support'])) {
      return const SizedBox.shrink();
    }

    return SettingsSectionWidget(
      title: 'About',
      children: [
        SettingsItemWidget(
          title: 'App Version',
          subtitle: '1.2.3 (Build 456)',
          iconName: 'info',
          onTap: () => _showVersionInfo(),
        ),
        SettingsItemWidget(
          title: 'Privacy Policy',
          subtitle: 'View our privacy policy',
          iconName: 'privacy_tip',
          onTap: () => _openPrivacyPolicy(),
        ),
        SettingsItemWidget(
          title: 'Terms of Service',
          subtitle: 'Read terms and conditions',
          iconName: 'description',
          onTap: () => _openTermsOfService(),
        ),
        SettingsItemWidget(
          title: 'Support',
          subtitle: 'Get help and contact us',
          iconName: 'support',
          onTap: () => _openSupport(),
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: OutlinedButton(
        onPressed: _showResetDialog,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.lightTheme.colorScheme.error,
          side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'restore',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Reset to Defaults',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(List<String> keywords) {
    return keywords.any((keyword) => keyword.contains(_searchQuery));
  }

  void _navigateToRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void _clearCache() async {
    setState(() => _isClearing = true);

    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isClearing = false;
      _cacheSize = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cache cleared successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _manualSync() async {
    setState(() => _isSyncing = true);

    // Simulate sync process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isSyncing = false;
      _lastSyncTime = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sync completed successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final currentPasswordController = TextEditingController();
        final newPasswordController = TextEditingController();
        final confirmPasswordController = TextEditingController();

        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and change password
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password changed successfully')),
                );
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _showAccessibilityOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accessibility Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                    iconName: 'text_fields',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
                title: Text('Font Size'),
                subtitle: Text('Adjust text size'),
                onTap: () {},
              ),
              ListTile(
                leading: CustomIconWidget(
                    iconName: 'contrast',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
                title: Text('High Contrast'),
                subtitle: Text('Improve visibility'),
                onTap: () {},
              ),
              ListTile(
                leading: CustomIconWidget(
                    iconName: 'voice_over_off',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
                title: Text('Screen Reader'),
                subtitle: Text('Enable voice assistance'),
                onTap: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showOfflineContentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Offline Content'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Manage content available offline:'),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                    iconName: 'folder',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
                title: Text('Projects (12 items)'),
                subtitle: Text('156 MB'),
                trailing: IconButton(
                  icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20),
                  onPressed: () {},
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                    iconName: 'image',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24),
                title: Text('Images (45 items)'),
                subtitle: Text('89 MB'),
                trailing: IconButton(
                  icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DataSci Portfolio',
                  style: AppTheme.lightTheme.textTheme.titleMedium),
              SizedBox(height: 1.h),
              Text('Version: 1.2.3'),
              Text('Build: 456'),
              Text('Release Date: July 15, 2025'),
              SizedBox(height: 2.h),
              Text('What\'s New:',
                  style: AppTheme.lightTheme.textTheme.titleSmall),
              Text('• Improved performance'),
              Text('• Bug fixes and stability'),
              Text('• New export features'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening Privacy Policy...')),
    );
  }

  void _openTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening Terms of Service...')),
    );
  }

  void _openSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening Support Center...')),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Settings'),
          content: Text(
              'Are you sure you want to reset all settings to their default values? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _resetToDefaults();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetToDefaults() {
    setState(() {
      _currentTheme = 'light';
      _currentLanguage = 'en';
      _biometricEnabled = true;
      _pushNotifications = true;
      _emailNotifications = true;
      _engagementAlerts = false;
      _portfolioPublic = true;
      _analyticsTracking = true;
      _contactFormEnabled = true;
      _cacheSize = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
