import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum AuthenticationStatus {
  idle,
  authenticating,
  success,
  failed,
  biometricNotEnrolled,
  tooManyAttempts,
  sensorUnavailable,
}

class AuthenticationStatusWidget extends StatefulWidget {
  final AuthenticationStatus status;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AuthenticationStatusWidget({
    super.key,
    required this.status,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<AuthenticationStatusWidget> createState() =>
      _AuthenticationStatusWidgetState();
}

class _AuthenticationStatusWidgetState extends State<AuthenticationStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(AuthenticationStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (widget.status) {
      case AuthenticationStatus.success:
        return AppTheme.lightTheme.colorScheme.tertiary;
      case AuthenticationStatus.failed:
      case AuthenticationStatus.biometricNotEnrolled:
      case AuthenticationStatus.tooManyAttempts:
      case AuthenticationStatus.sensorUnavailable:
        return AppTheme.lightTheme.colorScheme.error;
      case AuthenticationStatus.authenticating:
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String get _statusIcon {
    switch (widget.status) {
      case AuthenticationStatus.success:
        return 'check_circle';
      case AuthenticationStatus.failed:
        return 'error';
      case AuthenticationStatus.biometricNotEnrolled:
        return 'warning';
      case AuthenticationStatus.tooManyAttempts:
        return 'block';
      case AuthenticationStatus.sensorUnavailable:
        return 'sensors_off';
      case AuthenticationStatus.authenticating:
        return 'hourglass_empty';
      default:
        return 'info';
    }
  }

  String get _statusMessage {
    switch (widget.status) {
      case AuthenticationStatus.success:
        return 'Authentication successful!';
      case AuthenticationStatus.failed:
        return widget.errorMessage ??
            'Authentication failed. Please try again.';
      case AuthenticationStatus.biometricNotEnrolled:
        return 'Biometric authentication is not set up on this device.';
      case AuthenticationStatus.tooManyAttempts:
        return 'Too many failed attempts. Please wait before trying again.';
      case AuthenticationStatus.sensorUnavailable:
        return 'Biometric sensor is currently unavailable.';
      case AuthenticationStatus.authenticating:
        return 'Authenticating...';
      default:
        return '';
    }
  }

  bool get _shouldShowRetry {
    return widget.status == AuthenticationStatus.failed ||
        widget.status == AuthenticationStatus.sensorUnavailable;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == AuthenticationStatus.idle) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _statusColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (widget.status == AuthenticationStatus.authenticating)
                        SizedBox(
                          width: 6.w,
                          height: 6.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_statusColor),
                          ),
                        )
                      else
                        CustomIconWidget(
                          iconName: _statusIcon,
                          color: _statusColor,
                          size: 6.w,
                        ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: _statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_shouldShowRetry && widget.onRetry != null) ...[
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: widget.onRetry,
                        style: TextButton.styleFrom(
                          foregroundColor: _statusColor,
                          backgroundColor: _statusColor.withValues(alpha: 0.1),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Try Again',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: _statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
