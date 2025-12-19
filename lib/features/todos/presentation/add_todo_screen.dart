import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mentra_app/features/todos/data/todo_status.dart';
import 'package:mentra_app/utils/custom_extension.dart';

import '../providers/todo_provider.dart';

class CreateTodoScreen extends HookConsumerWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final endDateController = useTextEditingController();
    final todoNotifier = ref.read(todoListProvider.notifier);

    final status = useState<TodoStatus>(TodoStatus.none);

    void createTodo() {
      //print("end date $endDateController.text");
      todoNotifier.addTodo(
        titleController.text,
        descriptionController.text,
        status.value,
        endDateController.text.isNotEmpty
            ? DateTime.parse(endDateController.text)
            : null,
      );

      titleController.clear();
      descriptionController.clear();
      endDateController.clear();
      status.value = TodoStatus.none;
      context.replace('/todo');
    }

    final titleLive = useState<String>('');
    useEffect(() {
      print("on mounted");
      return () {
          status.dispose();
          titleController.dispose();
          descriptionController.dispose();
          endDateController.dispose();
          print("on dispose");
      }; // cleanup function if needed
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text("${context.loc!.add} ${context.loc!.task}")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.loc!.pleaseEnter(context.loc!.title);
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.loc!.title,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.loc!.pleaseEnter(context.loc!.description);
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.loc!.description,
                  border: OutlineInputBorder(),
                ),
              ),
              InputDatePickerFormField(
                fieldLabelText: context.loc!.endDate,
                firstDate: DateTime.now(),
                acceptEmptyDate: false,
                lastDate: DateTime.now().add(Duration(days: 30)),
                onDateSubmitted: (value) {
                  endDateController.text = value.toString();
                  print(endDateController.text);
                },
                onDateSaved: (value) {
                  endDateController.text = value.toString();
                  print(endDateController.text);
                },
              ),
              DropdownMenuFormField<TodoStatus>(
                label: Text(context.loc!.status),
                // hintText: "None",
                validator: (value) {
                  if (value == null || value == TodoStatus.none) {
                    return context.loc!.pleaseSelect(context.loc!.status);
                  }
                  return null;
                },
                onSelected: (value) {
                  status.value = value!;
                 // print(value);
                },
                initialSelection: status.value,
                dropdownMenuEntries: [
                  for (var status in TodoStatus.values)
                    DropdownMenuEntry(value: status, label: status.getTitle(context)),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    createTodo();
                  }
                },
                child: Text(context.loc!.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
