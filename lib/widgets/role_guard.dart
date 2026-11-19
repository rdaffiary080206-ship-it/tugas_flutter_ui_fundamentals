import 'package:flutter/material.dart';

class RoleGuard extends StatelessWidget {
  final String userRole;
  final List<String> allowedRoles;
  final Widget child;
  final Widget fallback;

  const RoleGuard({
    super.key,
    required this.userRole,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    if (allowedRoles.contains(userRole)) {
      return child;
    }
    return fallback;
  }
}
