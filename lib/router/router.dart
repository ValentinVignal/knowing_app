import 'package:go_router/go_router.dart';
import 'package:knowing_app/router/routes.dart';

final router = GoRouter(
  initialLocation: '/analyze',
  routes: $appRoutes,
);
