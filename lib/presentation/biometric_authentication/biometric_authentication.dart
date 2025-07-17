
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/authentication_status_widget.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/pin_pad_widget.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({super.key});

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication>
    with TickerProviderStateMixin {
  bool _showPinPad = false;
  bool _isLoading = false;
  AuthenticationStatus _authStatus = AuthenticationStatus.idle;
  String? _errorMessage;
  String _biometricType = 'Fingerprint';

  // Mock credentials for authentication
  final String _correctPin = '123456';
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'admin_001',
      'name': 'Dr. Sarah Chen',
      'role': 'Senior Data Scientist',
      'pin': '123456',
      'biometricEnabled': true,
    },
    {
      'id': 'admin_002',
      'name': 'Prof. Michael Rodriguez',
      'role': 'ML Research Lead',
      'pin': '654321',
      'biometricEnabled': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _detectBiometricType();
  }

  void _detectBiometricType() {
    // Simulate biometric type detection based on platform
    setState(() {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        _biometricType = 'Face ID';
      } else {
        _biometricType = 'Fingerprint';
      }
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _authStatus = AuthenticationStatus.authenticating;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random success/failure for demo
      final bool success = DateTime.now().millisecond % 3 != 0;

      if (success) {
        HapticFeedback.heavyImpact();
        setState(() {
          _authStatus = AuthenticationStatus.success;
        });

        await Future.delayed(const Duration(milliseconds: 1500));
        _navigateToDashboard();
      } else {
        HapticFeedback.heavyImpact();
        setState(() {
          _authStatus = AuthenticationStatus.failed;
          _errorMessage =
              'Biometric authentication failed. Please try again or use PIN.';
        });
      }
    } catch (e) {
      setState(() {
        _authStatus = AuthenticationStatus.sensorUnavailable;
        _errorMessage = 'Biometric sensor is currently unavailable.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _authenticateWithPin(String pin) async {
    setState(() {
      _isLoading = true;
      _authStatus = AuthenticationStatus.authenticating;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (pin == _correctPin) {
      HapticFeedback.heavyImpact();
      setState(() {
        _authStatus = AuthenticationStatus.success;
      });

      await Future.delayed(const Duration(milliseconds: 1500));
      _navigateToDashboard();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _authStatus = AuthenticationStatus.failed;
        _errorMessage = 'Incorrect PIN. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, '/portfolio-dashboard');
  }

  void _showPinPadScreen() {
    setState(() {
      _showPinPad = true;
      _authStatus = AuthenticationStatus.idle;
    });
  }

  void _hidePinPadScreen() {
    setState(() {
      _showPinPad = false;
      _authStatus = AuthenticationStatus.idle;
    });
  }

  void _retryAuthentication() {
    setState(() {
      _authStatus = AuthenticationStatus.idle;
      _errorMessage = null;
    });
  }

  void _navigateToPublicPortfolio() {
    Navigator.pushReplacementNamed(context, '/projects-gallery');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100.h - MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  children: [
                    // Header with back button
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _navigateToPublicPortfolio,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .lightTheme.colorScheme.shadow
                                        .withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CustomIconWidget(
                                iconName: 'arrow_back',
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                size: 5.w,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Admin Access',
                              textAlign: TextAlign.center,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 9.w), // Balance the back button
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // App Logo
                    const AppLogoWidget(),

                    SizedBox(height: 6.h),

                    // Authentication content
                    Expanded(
                      child: _showPinPad
                          ? PinPadWidget(
                              onPinEntered: _authenticateWithPin,
                              onBackPressed: _hidePinPadScreen,
                              isLoading: _isLoading,
                            )
                          : BiometricPromptWidget(
                              onBiometricPressed: _authenticateWithBiometrics,
                              isLoading: _isLoading,
                              biometricType: _biometricType,
                            ),
                    ),

                    // Authentication status
                    AuthenticationStatusWidget(
                      status: _authStatus,
                      errorMessage: _errorMessage,
                      onRetry: _retryAuthentication,
                    ),

                    // Alternative authentication options
                    if (!_showPinPad && !_isLoading) ...[
                      SizedBox(height: 2.h),
                      TextButton(
                        onPressed: _showPinPadScreen,
                        style: TextButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.tertiary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'pin',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Use PIN Instead',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 4.h),

                    // Security notice
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Your biometric data is processed locally and never stored or transmitted.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
}
