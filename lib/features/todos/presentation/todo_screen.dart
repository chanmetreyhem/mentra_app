import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentra_app/core/widgets/step_line.dart';
import 'package:mentra_app/features/todos/data/todo_status.dart';
import 'package:mentra_app/features/todos/providers/todo_provider.dart';
import 'package:mentra_app/utils/utils.dart';

import '../../../core/enums/filter_type.dart';
import '../../../core/widgets/progress_indicator.dart';

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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search todosFilters...',
                        prefixIcon: Icon(Icons.search),
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
                                      ? Utils.getColorFromFilterType(filter)
                                      : Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                filter.name,
                                style: TextStyle(
                                  color: filterNotifier.state == filter
                                      ? Utils.getColorFromFilterType(filter)
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          CustomProgressIndicator(
                            status: "In Completed",
                            color: Utils.getColorFromStatus(
                              TodoStatus.onCompleted,
                            ),
                            value: onCompleted,
                          ),
                          CustomProgressIndicator(
                            status: "In Progress",
                            color: Utils.getColorFromStatus(
                              TodoStatus.inProgress,
                            ),
                            value: inProgress,
                          ),
                          CustomProgressIndicator(
                            status: "Not Started",
                            color: Utils.getColorFromStatus(
                              TodoStatus.notStarted,
                            ),
                            value: notStarted,
                          ),
                        ],
                      ),
                    ),
                    Text("Total : $total"),
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
                                  return ListTile(
                                    leading: StepLine(
                                      color: Utils.getColorFromStatus(
                                        todo.status ?? TodoStatus.notStarted,
                                      ),
                                    ),
                                    title: Text(todo.title),
                                    subtitle: Column(
                                      crossAxisAlignment: .start,
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 2,
                                      children: [
                                        Text(todo.description),
                                        Text(
                                          todo.createDate.isBefore(
                                                DateTime.now(),
                                              )
                                              ? "Created : ${todo.createDate.day}/${todo.createDate.month}/${todo.createDate.year}"
                                              : "Created : ${todo.createDate.day}/${todo.createDate.month}/${todo.createDate.year}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          todo.status.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          //padding: EdgeInsets.all(3),
                                          height: 20,
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(
                                              color: Utils.getColorFromStatus(
                                                todo.status ?? TodoStatus.notStarted,
                                              ),
                                            ),

                                          ),
                                          child: DropdownButton<TodoStatus>(
                                            menuMaxHeight: 90,
                                           // isExpanded: true,
                                            barrierDismissible: true,
                                            iconEnabledColor: Utils.getColorFromStatus(
                                              todo.status ?? TodoStatus.notStarted,
                                            ),
                                            alignment: Alignment.center,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            dropdownColor: Colors.white,
                                            underline: Container(
                                              height:1 ),
                                            selectedItemBuilder: (context) {
                                              return [
                                               for(var status in TodoStatus.values)
                                                 Center(child: Text("status: ${status.name}" ,style: TextStyle(color: Utils.getColorFromStatus(status)),))
                                              ];
                                            },
                                          
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            value: todo.status,
                                            items: <DropdownMenuItem<TodoStatus>>[
                                              for (var status
                                                  in TodoStatus.values)
                                                DropdownMenuItem<TodoStatus>(
                                                  value: status,
                                                  child: Text(status.name),
                                                ),
                                            ],
                                            onChanged: (value) {
                                              todoNotifier.updateTodoStatus(
                                                todo,
                                                value!,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitleTextStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    //tileColor: Colors.grey.withAlpha(50),
                                    trailing: IconButton(
                                      onPressed: () {
                                        //showAboutDialog(context: context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Message"),
                                            content: Text(
                                              "Are you sure you want to delete this task?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  todoNotifier.removeTodo(todo);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                    onTap: () {
                                      context.push('/todo/detail', extra: todo);
                                    },
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
}
