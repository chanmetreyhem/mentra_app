import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentra_app/features/setting/presentation/setting_screen.dart';
import 'package:mentra_app/features/todos/presentation/todo_screen.dart';
import 'package:mentra_app/utils/custom_extension.dart';
import 'features/todos/presentation/add_todo_screen.dart';
import 'features/todos/presentation/todo_description.dart';

final _routeNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  //navigatorKey: _routeNavigatorKey,
  initialLocation: '/todo',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
        // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
        return ScaffoldWithNavbar(navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/todo',
              builder: (context, state) => const TodoScreen(),
              routes: [
                GoRoute(
                  path: '/detail',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurveTween(
                                curve: Curves.easeInOutCirc,
                              ).animate(animation),
                              child: child,
                            );
                          },
                      child: TodoDetailScreen(todo: state.extra as dynamic),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          //navigatorKey: _sectionNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/add',
              builder: (context, state) => const CreateTodoScreen(),
              routes: <RouteBase>[],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'setting',
      path: '/setting',
      builder: (context, state) => SettingScreen(),
    ),
  ],
  //  redirect: (context, state) {},
);

class ScaffoldWithNavbar extends StatefulWidget {
  const ScaffoldWithNavbar(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavbar> createState() => _ScaffoldWithNavbarState();
}

class _ScaffoldWithNavbarState extends State<ScaffoldWithNavbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(index, initialLocation: index == 0);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: context.loc!.home),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: context.loc!.add),
        ],
      ),
    );
  }
}


