import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowing_app/router/router.dart';
import 'package:knowing_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: getTheme(Brightness.light),
        darkTheme: getTheme(Brightness.dark),
        title: 'Knowing',
        routerConfig: router,
      ),
    );
  }
}
