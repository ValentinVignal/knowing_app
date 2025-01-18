import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowing_app/screens/analyze.dart';
import 'package:knowing_app/screens/form.dart';

part 'routes.g.dart';

@TypedGoRoute<AnalyzeRoute>(
  path: '/analyze',
)
class AnalyzeRoute extends GoRouteData {
  const AnalyzeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AnalyzeScreen();
}

@TypedGoRoute<HomeRoute>(
  path: '/form',
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const FormScreen();
}
