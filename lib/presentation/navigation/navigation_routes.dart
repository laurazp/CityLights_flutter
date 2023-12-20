// ignore_for_file: constant_identifier_names

import 'package:citylights/presentation/view/favorite/favorites_page.dart';
import 'package:citylights/presentation/view/home/home_page.dart';
import 'package:citylights/presentation/view/map/map_page.dart';
import 'package:citylights/presentation/view/monument/monuments_page.dart';
import 'package:citylights/presentation/view/splash/splash_page.dart';
import 'package:go_router/go_router.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";
  static const MONUMENTS_ROUTE = "/monuments";
  static const MAP_ROUTE = "/map";
  static const FAVORITES_ROUTE = "/favorites";
  static const MONUMENT_DETAIL_ROUTE =
      "$MONUMENTS_ROUTE/$_MONUMENT_DETAIL_PATH";
  static const FAVORITE_DETAIL_ROUTE =
      "$FAVORITES_ROUTE/$_FAVORITE_DETAIL_PATH";

  static const _MONUMENT_DETAIL_PATH = "monument-detail";
  static const _FAVORITE_DETAIL_PATH = "favorite-detail";
}

final GoRouter router =
    GoRouter(initialLocation: NavigationRoutes.INITIAL_ROUTE, routes: [
  GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage()),
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomePage(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.MONUMENTS_ROUTE,
            builder: (context, state) => const MonumentsPage(),
            /*routes: [
              GoRoute(
                path: NavigationRoutes._MONUMENT_DETAIL_PATH,
                builder: (context, state) => const MonumentDetailPage(),
              )
            ],*/
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.MAP_ROUTE,
            builder: (context, state) => const MapPage(),
          )
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.FAVORITES_ROUTE,
            builder: (context, state) => const FavoritesPage(),
            /*routes: [
              GoRoute(
                path: NavigationRoutes._FAVORITE_DETAIL_PATH,
                builder: (context, state) => const FavoriteDetailPage(),
              )
            ],*/
          )
        ])
      ])
]);
