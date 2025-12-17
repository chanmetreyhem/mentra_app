import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../providers/todo_provider.dart';
class CreateTodoScreen extends HookConsumerWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final todoNotifier = ref.read(todoListProvider.notifier);
    final mounted = useIsMounted();
    void createTodo() {
      todoNotifier.addTodo(titleController.text, descriptionController.text);
      titleController.clear();
      descriptionController.clear();
      context.go('/todo');
    }

    final titleLive = useState<String>('');
    useEffect(() {
      print("on mounted");
      return () {
        print("cleanup");
      }; // cleanup function if needed
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text("Create Todo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("title : ${titleLive.value}"),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
              onChanged: (value) => titleLive.value = value,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            ElevatedButton(
              onPressed: () {
                createTodo();
              },
              child: Text("Create Todo"),
            ),
          ],
        ),
      ),
    );
  }
}