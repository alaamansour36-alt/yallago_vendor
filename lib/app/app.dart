import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/shared/app_scope.dart';
import '../features/vendor/presentation/vendor_app.dart';

class YallaGoApp extends StatefulWidget {
  const YallaGoApp({super.key});

  @override
  State<YallaGoApp> createState() => _YallaGoAppState();
}

class _YallaGoAppState extends State<YallaGoApp> {
  int _cartCount = 2;

  @override
  Widget build(BuildContext context) {
    return YallaScope(
      cartCount: _cartCount,
      updateCart: (value) => setState(() => _cartCount = value.clamp(0, 99)),
      child: MaterialApp(
        title: 'YallaGo',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: const VendorAppShell(),
      ),
    );
  }
}
