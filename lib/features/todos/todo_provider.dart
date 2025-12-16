import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentra_app/features/todos/todo_state.dart';

final searchQueryProvider = Provider<String>((ref) => '1');
final todoProvider = NotifierProvider<TodoNotifier, List<TodoState>>(
  TodoNotifier.new,
);

final filteredTodosProvider = Provider.family<List<TodoState>, String>((
  ref,
  query,
) {
  final todos = ref.watch(todoProvider);
  if (query.isEmpty) return todos;
  return todos
      .where(
        (t) =>
            t.title.toLowerCase().contains(query.toLowerCase()) ||
            t.description.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
});

class TodoNotifier extends Notifier<List<TodoState>> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  @override
  List<TodoState> build() {
    return [];
  }

  Future<void> addTodo(String title, String description) async {
    _isLoading = true;
    await Future.delayed(Duration(microseconds: 10000));
    var todo = TodoState(
      title: title,
      description: description,
      isCompleted: false,
      createDate: DateTime.now(),
    );
    if (!ref.mounted) return;
    state = [...state, todo];
    _isLoading = false;
  }

  void removeTodo(TodoState todo) {
    state = state.where((t) {
      return t != todo;
    }).toList();
  }

  void updateCompletedTodo(bool isCompleted, TodoState todo) {
    state = state.map((t) {
      if (t == todo) {
        return t.copyWith(isCompleted: isCompleted);
      }
      return t;
    }).toList();
  }

  void getAllCompletedTodo() {
    state = state.where((t) => t.isCompleted == true).toList();
  }
}
