import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentra_app/features/todos/todo_description.dart';
import 'package:mentra_app/features/todos/todo_provider.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.read(todoProvider.notifier);
    final todos = ref.watch(filteredTodosProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: [
          IconButton(
            onPressed: () {
              todoNotifier.getAllCompletedTodo();
            },
            icon: Icon(Icons.get_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action when button is pressed
          todoNotifier.addTodo(
            "Hello ${Random().nextInt(1000)}",
            "//jfjd ieirier  jdjf df ierie r ierieirri iriri szsd errr",
          );
        },
        child: Icon(Icons.add), // Icon inside the FAB
        tooltip: "Add Item", // Tooltip when long-pressed
      ),

      body: todoNotifier.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search todos...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      //  ref.read(searchQueryProvider).sta = value;
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: todos.isEmpty
                      ? Center(
                          child: Text(
                            "not task",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: List.generate(todos.length, (i) {
                              final todo = todos[i];
                              return ListTile(
                                autofocus: true,
                                leading: Text((i + 1).toString()),
                                title: Text(todo.title),
                                subtitle: Text(todo.description),
                                trailing: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (state) {
                                    todoNotifier.updateCompletedTodo(
                                      state!,
                                      todo,
                                    );
                                  },
                                ),
                                onLongPress: () =>
                                    todoNotifier.removeTodo(todo),
                                onTap: () {context.push('/todo/detail',extra: todo);


                                },
                              );
                            }),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
