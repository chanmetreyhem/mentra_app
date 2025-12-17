import 'package:mentra_app/features/todos/data/todo_state.dart';
import 'package:mentra_app/features/todos/data/todo_status.dart';

class TodoRepository {
   List<TodoState> todos = [];
   void addTodo(String title,String des){
      var todo = TodoState(
        title: title,
        description: des,
        isCompleted: false,
        createDate: DateTime.now(),
          status: TodoStatus.notStarted
      );
      todos = [...todos,todo];

   }
}