// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:freezed_provider_value_notifier/models.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'todo_list_model.freezed.dart';

enum VisibilityFilter { all, active, completed }

@freezed
abstract class TodoList with _$TodoList {
  TodoList._();
  factory TodoList(
    List<Todo> todos, {
    @required VisibilityFilter filter,
    @required bool loading,
  }) = TodoListState;

  bool get hasCompleted => numCompleted > 0;

  bool get hasActiveTodos => numActive > 0;

  @late
  int get numCompleted => todos.where((todo) => todo.complete).toList().length;

  @late
  int get numActive => todos.where((todo) => !todo.complete).toList().length;

  @late
  List<Todo> get filteredTodos => todos.where((todo) {
        switch (filter) {
          case VisibilityFilter.active:
            return !todo.complete;
          case VisibilityFilter.completed:
            return todo.complete;
          case VisibilityFilter.all:
          default:
            return true;
        }
      }).toList();

  Todo todoById(String id) {
    return todos.firstWhere((it) => it.id == id, orElse: () => null);
  }
}

class TodoListController extends StateNotifier<TodoList> {
  TodoListController({
    VisibilityFilter filter = VisibilityFilter.all,
    @required this.todosRepository,
    List<Todo> todos = const [],
  })  : assert(todosRepository != null),
        super(TodoList(todos, filter: filter, loading: false)) {
    _loadTodos();
  }

  final TodosRepository todosRepository;

  set filter(VisibilityFilter filter) {
    state = state.copyWith(filter: filter);
  }

  @override
  @protected
  set state(TodoList newState) {
    if (!const DeepCollectionEquality().equals(state.todos, newState.todos)) {
      todosRepository.saveTodos(
        newState.todos.map((it) => it.toEntity()).toList(),
      );
    }
    super.state = newState;
  }

  Future<void> _loadTodos() async {
    state = (state.copyWith(loading: true));

    try {
      final todos = await todosRepository.loadTodos();
      state = state.copyWith(
        todos: todos.map(Todo.fromEntity).toList(),
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  void addTodo(Todo todo) {
    state = state.copyWith(todos: [...state.todos, todo]);
  }

  void updateTodo(Todo updatedTodo) {
    state = state.copyWith(todos: [
      for (final todo in state.todos)
        if (todo.id == updatedTodo.id) updatedTodo else todo,
    ]);
  }

  void removeTodoWithId(String id) {
    state = state.copyWith(todos: [
      for (final todo in state.todos) if (todo.id != id) todo,
    ]);
  }

  void toggleAll() {
    final allComplete = state.todos.every((todo) => todo.complete);
    state = state.copyWith(todos: [
      for (final todo in state.todos) todo.copy(complete: !allComplete),
    ]);
  }

  void clearCompleted() {
    state = state.copyWith(
      todos: state.todos.where((todo) => !todo.complete).toList(),
    );
  }
}
