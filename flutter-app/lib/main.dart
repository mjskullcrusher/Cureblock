import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CureBlockApp()));
}

class CureBlockApp extends ConsumerWidget {
  const CureBlockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CureBlock',
      debugShowCheckedModeBanner: false,
      theme: LightTheme.data,
      darkTheme: DarkTheme.data,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
