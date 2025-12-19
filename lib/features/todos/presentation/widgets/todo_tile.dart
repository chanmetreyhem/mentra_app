import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/widgets/step_line.dart';
import '../../../../main.dart';
import '../../../../utils/custom_extension.dart';
import '../../../../utils/utils.dart';
import '../../data/todo_state.dart';
import '../../data/todo_status.dart';
import '../../providers/todo_provider.dart';

class TodoTile extends HookConsumerWidget {
  final TodoState todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoListProvider.notifier);
    final color = Utils.getColorFromStatus(todo.status!);
    return  ListTile(
      leading: StepLine(color: color),
      splashColor: color.withAlpha(100),
      title: Text(todo.title),
      textColor: context.theme.primaryColor,
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
                : "Created : ${todo.completedDate!.day}/${todo.completedDate!.month}/${todo.completedDate!.year}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
         // Text("${todo.completedDate}"),
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
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                100,
              ),
              border: Border.all(color: color),
            ),
            child: DropdownButton<TodoStatus>(
              menuMaxHeight: 90,
              // isExpanded: true,
              barrierDismissible: true,
              iconEnabledColor: color,
              alignment: Alignment.center,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              dropdownColor: Colors.white,
              underline: Container(height: 1),
              selectedItemBuilder: (context) {
                return [
                  for (var status
                  in TodoStatus.values)
                    Center(
                      child: Text(
                        "${context.loc!.status}: ${status.getTitle(context)}",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                ];
              },

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              value: todo.status,
              items:
              <DropdownMenuItem<TodoStatus>>[
                for (var status
                in TodoStatus.values)
                  DropdownMenuItem<
                      TodoStatus
                  >(
                    value: status,
                    child: Text(status.getTitle(context),style: TextStyle(color: Colors.black)),
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
              title: Text(context.loc!.message),
              content: Text(
              context.loc!.deleteMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(context.loc!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    todoNotifier.removeTodo(todo);
                    Navigator.pop(context);
                  },
                  child: Text(context.loc!.ok),
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
  }
}
