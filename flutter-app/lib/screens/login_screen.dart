import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../theme/light_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'user@cureblock.app');
  final _passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    signIn(ref, role: ref.read(roleProvider));
    final role = ref.read(roleProvider);
    context.go(switch (role) {
      UserRole.parent => '/parent/home',
      UserRole.operator => '/operator/home',
      UserRole.admin => '/admin/home',
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ext = CureBlockThemeExtension.of(context);
    final brandColor = isDark ? AppColors.primaryBrandDark : AppColors.primaryBrand;
    final scaffoldColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.5),
            radius: 1.15,
            colors: [
              brandColor.withValues(alpha: 0.05),
              brandColor.withValues(alpha: 0.025),
              scaffoldColor,
            ],
            stops: const [0.0, 0.42, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      _ShieldLogo(color: theme.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'CureBlock',
                        style: theme.textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      _RolePillSelector(
                        selected: role,
                        onSelected: (r) => ref.read(roleProvider.notifier).state = r,
                      ),
                      const SizedBox(height: 28),
                      _LoginTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _LoginTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: true,
                        isDark: isDark,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _signIn,
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'A shield that never sleeps',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ext.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Center(child: _LoginThemeFooter()),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShieldLogo extends StatelessWidget {
  const _ShieldLogo({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.28),
              blurRadius: 28,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 48,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Icon(Icons.shield_rounded, size: 88, color: color),
      ),
    );
  }
}

class _RolePillSelector extends StatelessWidget {
  const _RolePillSelector({
    required this.selected,
    required this.onSelected,
  });

  final UserRole selected;
  final ValueChanged<UserRole> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outlineColor = isDark ? AppColors.dividerDark : AppColors.divider;

    return Row(
      children: UserRole.values.map((role) {
        final isSelected = role == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: role == UserRole.parent ? 0 : 4,
              right: role == UserRole.admin ? 0 : 4,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(role),
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : outlineColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    role.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.isDark,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final bool isDark;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark ? const Color(0xFF1A2233) : const Color(0xFFF1F5F9);
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.accent.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginThemeFooter extends ConsumerWidget {
  const _LoginThemeFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final ext = CureBlockThemeExtension.of(context);

    return InkWell(
      onTap: () => ref.read(themeProvider.notifier).toggleLightDark(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: 22,
                color: ext.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isDark ? 'Light mode' : 'Dark mode',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ext.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
