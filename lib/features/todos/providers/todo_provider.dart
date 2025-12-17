import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mentra_app/core/enums/filter_type.dart';
import 'package:mentra_app/features/todos/data/todo_repository.dart';
import 'package:mentra_app/features/todos/data/todo_state.dart';
import 'package:mentra_app/features/todos/data/todo_status.dart';
final todoRepositoryProvider = Provider<TodoRepository>((ref) => TodoRepository());

final todoListProvider = NotifierProvider<TodoNotifier, List<TodoState>>(TodoNotifier.new);

final filterProvider = StateProvider<FilterType>((ref) {
  return FilterType.all;
});

final filteredTodosProvider =
    Provider.family<List<TodoState>, (String, FilterType?)>((ref, arg) {
      String query = arg.$1;
      FilterType filterType = arg.$2 ?? ref.watch(filterProvider);
      List<TodoState> todos = ref.watch(todoListProvider);
      if(query.length > 2){
        todos = todos.where((t) => t.title.toLowerCase().contains(query.toLowerCase())).toList();
      }
      switch (filterType) {
        case FilterType.all:
          return todos;
        case FilterType.notStarted:
          return todos.where((t) => t.status == TodoStatus.notStarted).toList();
        case FilterType.inProgress:
          return todos.where((t) => t.status == TodoStatus.inProgress).toList();
        case FilterType.onCompleted:
          return todos.where((t) => t.status == TodoStatus.onCompleted).toList();
      }
    });

class TodoNotifier extends Notifier<List<TodoState>> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  @override
  List<TodoState> build() {
    return [
      TodoState(
        title: "Buy groceries",
        description: "Milk, eggs, bread, and fruits",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Morning workout",
        description: "30 minutes of cardio and stretching",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 1)),
        completedDate: DateTime.now().subtract(Duration(days: 1, hours: -1)),
      ),
      TodoState(
        title: "Read a book",
        description: "Finish 20 pages of current novel",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Call parents",
        description: "Catch up with family",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 2)),
        completedDate: DateTime.now().subtract(Duration(days: 2, hours: -2)),
      ),
      TodoState(
        title: "Clean the house",
        description: "Vacuum and mop floors",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Pay electricity bill",
        description: "Due by end of the week",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 3)),
        completedDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      TodoState(
        title: "Write blog post",
        description: "Topic: Productivity hacks",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Plan weekend trip",
        description: "Book tickets and hotel",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Team meeting",
        description: "Discuss project milestones",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 1)),
        completedDate: DateTime.now().subtract(Duration(hours: 5)),
      ),
      TodoState(
        title: "Update resume",
        description: "Add latest work experience",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Water plants",
        description: "Indoor and outdoor plants",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 1)),
        completedDate: DateTime.now().subtract(Duration(hours: 12)),
      ),
      TodoState(
        title: "Organize desk",
        description: "Declutter workspace",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Backup files",
        description: "Save important documents to cloud",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 4)),
        completedDate: DateTime.now().subtract(Duration(days: 3)),
      ),
      TodoState(
        title: "Cook dinner",
        description: "Try new pasta recipe",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Meditation",
        description: "15 minutes mindfulness practice",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 1)),
        completedDate: DateTime.now().subtract(Duration(hours: 20)),
      ),
      TodoState(
        title: "Laundry",
        description: "Wash and fold clothes",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Check emails",
        description: "Respond to pending messages",
        isCompleted: false,
        createDate: DateTime.now().subtract(Duration(days: 2)),
        completedDate: DateTime.now().subtract(Duration(days: 2, hours: -1)),
      ),
      TodoState(
        title: "Study Flutter",
        description: "Learn about state management",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Car maintenance",
        description: "Oil change and tire check",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
      TodoState(
        title: "Plan birthday party",
        description: "Guest list and decorations",
        isCompleted: false,
        createDate: DateTime.now(),
      ),
    ];
  }


  Future<void> addTodo(String title, String description) async {
    _isLoading = true;
    await Future.delayed(Duration(microseconds: 10000));
    var todo = TodoState(
      title: title,
      description: description,
      isCompleted: false,
      createDate: DateTime.now(),
      status: TodoStatus.notStarted
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
  void updateTodoStatus(TodoState todo,TodoStatus status){
    state = state.map((t) {
      if(t == todo){
        return t.copyWith(status: status);
      }
      return t;
    }).toList();
  }

  void toggleTodoStatus(bool isCompleted,TodoState todo){
     state = state.map((t) {
       if(t == todo){
         return t.copyWith(isCompleted: isCompleted,status: isCompleted ? TodoStatus.onCompleted : TodoStatus.notStarted);
       }
       return t;
     }).toList();
  }



  void getAllCompletedTodo() {
    state = state.where((t) => t.isCompleted == true).toList();
  }
}
