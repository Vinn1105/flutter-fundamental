
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  final String title;
  final bool done;

  const Todo(
    this.title, {
    this.done = false,
  });

  Todo copyWith({
    String? title,
    bool? done,
  }) {
    return Todo(
      title ?? this.title,
      done: done ?? this.done,
    );
  }
}

class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }

  void add(String title) {
    state = [
      ...state,
      Todo(title),
    ];
  }

  void toggle(int index) {
    final updatedTodos = [...state];

    updatedTodos[index] = updatedTodos[index].copyWith(
      done: !updatedTodos[index].done,
    );

    state = updatedTodos;
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);
