import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentra_app/features/todos/providers/todo_provider.dart';
import 'package:mentra_app/features/todos/data/todo_state.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  late TodoState todo;
  String? title;
  TodoDetailScreen({super.key, required this.todo, this.title});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.read(todoListProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo.title),
        actions: [
          IconButton(
            onPressed: () {
              todoNotifier.removeTodo(widget.todo);
              context.pop();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.todo.description),
            Text('title : ${widget.title ?? 'unknow'}'),
          ],
        ),
      ),
    );
  }
}
