import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowing_app/screens/analyze.dart';
import 'package:knowing_app/screens/form.dart';

part 'routes.g.dart';

@TypedGoRoute<AnalyzeRoute>(
  path: '/analyze',
)
class AnalyzeRoute extends GoRouteData {
  const AnalyzeRoute({
    this.date,
  });

  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProviderScope(
        overrides: [
          dateOverrideProvider.overrideWithValue(date),
        ],
        child: AnalyzeScreen(),
      );
}

@TypedGoRoute<HomeRoute>(
  path: '/form',
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FormScreen();
}
