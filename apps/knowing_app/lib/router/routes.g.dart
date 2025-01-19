// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $analyzeRoute,
      $homeRoute,
    ];

RouteBase get $analyzeRoute => GoRouteData.$route(
      path: '/analyze',
      factory: $AnalyzeRouteExtension._fromState,
    );

extension $AnalyzeRouteExtension on AnalyzeRoute {
  static AnalyzeRoute _fromState(GoRouterState state) => AnalyzeRoute(
        date: state.uri.queryParameters['date'],
      );

  String get location => GoRouteData.$location(
        '/analyze',
        queryParams: {
          if (date != null) 'date': date,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/form',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/form',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
