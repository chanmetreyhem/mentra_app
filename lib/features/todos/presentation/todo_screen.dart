import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentra_app/features/todos/data/todo_status.dart';
import 'package:mentra_app/features/todos/presentation/widgets/todo_tile.dart';
import 'package:mentra_app/features/todos/providers/todo_provider.dart';
import 'package:mentra_app/utils/utils.dart';
import '../../../core/enums/filter_type.dart';
import '../../../core/widgets/progress_indicator.dart';
import '../../../utils/custom_extension.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.read(todoListProvider.notifier);
    final todosFilters = ref.watch(filteredTodosProvider((searchQuery, null)));
    final filterNotifier = ref.read(filterProvider.notifier);
    final todos = ref.watch(todoListProvider);
    int total = todos.length;

    double inProgress = total == 0
        ? 0
        : todos.where((t) => t.status == TodoStatus.inProgress).length / total;

    double notStarted = total == 0
        ? 0
        : todos.where((t) => t.status == TodoStatus.notStarted).length / total;

    double onCompleted = total == 0
        ? 0
        : todos.where((t) => t.status == TodoStatus.onCompleted).length / total;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Task", style: TextStyle(fontSize: 30)),
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed('setting');
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: todoNotifier.isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: .start,
                  children: [
                    TextField(
                      style: TextStyle(color: context.theme.primaryColor),
                      cursorColor: context.theme.primaryColor,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: context.loc!.search,
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        //  ref.read(searchQueryProvider).sta = value;
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        for (var filter in FilterType.values)
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            //splashFactory: InkRipple.splashFactory,
                            splashColor: Utils.getColorFromFilterType(
                              filter,
                              context,
                            ).withAlpha(100),
                            onTap: () => filterNotifier.state = filter,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: filterNotifier.state == filter
                                      ? Utils.getColorFromFilterType(
                                          filter,
                                          context,
                                        )
                                      : Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                filter.name,
                                style: TextStyle(
                                  color: filterNotifier.state == filter
                                      ? Utils.getColorFromFilterType(
                                          filter,
                                          context,
                                        )
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    _todoProgressDataGroup(inProgress, notStarted, onCompleted),
                    Text(
                    "${context.loc!.total} : $total",
                      style: TextStyle(color: context.theme.primaryColor),
                    ),
                    Expanded(
                      child: todosFilters.isEmpty
                          ? Center(
                              child: Text(
                                "not task",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: List.generate(todosFilters.length, (
                                  i,
                                ) {
                                  final todo = todosFilters[i];
                                  final color = Utils.getColorFromStatus(
                                    todo.status ?? TodoStatus.notStarted,
                                  );
                                  return TodoTile(
                                    todo: todo,
                                  );
                                }),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  SizedBox _todoProgressDataGroup(
    double inProgress,
    double notStarted,
    double onCompleted,
  ) => SizedBox(
    child: Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        CustomProgressIndicator(
          status: context.loc!.notStarted,
          color: Utils.getColorFromStatus(TodoStatus.onCompleted),
          value: onCompleted,
        ),
        CustomProgressIndicator(
          status: context.loc!.inProgress,
          color: Utils.getColorFromStatus(TodoStatus.inProgress),
          value: inProgress,
        ),
        CustomProgressIndicator(
          status: context.loc!.completed,
          color: Utils.getColorFromStatus(TodoStatus.notStarted),
          value: notStarted,
        ),
      ],
    ),
  );
}
