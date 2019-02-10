import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_mobx_hooks/flutter_mobx_hooks.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:flutter_architecture_samples/uuid.dart';

part 'todos.g.dart';

final _uuid = Uuid();

Todos useTodos() {
  useObserver();
  return Provider.of<Todos>(useContext());
}

enum VisibilityFilter { all, active, completed }

class Todos = _Todos with _$Todos;

abstract class _Todos implements Store {
  _Todos(this._repository);

  final TodosRepository _repository;

  @observable
  var filter = VisibilityFilter.all;

  @observable
  var loading = false;

  @observable
  var saving = false;

  @observable
  List<Todo> todos = ObservableList();

  @computed
  bool get hasCompletedTodos => todos.any((todo) => todo.completed);

  @action
  Future<void> addTodo(Todo todo) => _trySave(List.of(todos)..add(todo));

  @action
  Future<void> removeTodo(String id) =>
      _trySave(todos.where((todo) => todo.id != id));

  @action
  Future<void> _trySave(Iterable<Todo> newTodos) async {
    assert(!saving && !loading);

    final tmp = todos;
    // visually commit the changes
    todos = ObservableList.of(newTodos);

    saving = true;
    try {
      await _repository
          .saveTodos(todos.map((todo) => todo.toEntity()).toList());
    }
    catch (err) {
      // if something failed, revert the visual change
      todos = tmp;
      rethrow;
    } finally {
      saving = false;
    }
  }

  @action
  Future<void> loadTodos() async {
    assert(!loading);
    loading = true;
    try {
      todos = ObservableList<Todo>.of((await _repository.loadTodos())
          .map((entity) => Todo._fromEntity(entity)));
    } finally {
      loading = false;
    }
  }

  @action
  void onFilterChanged(VisibilityFilter filter) {
    this.filter = filter;
  }

  @action
  void clearAll() {}

  @action
  void completeAll() {}
}

class Todo = _Todo with _$Todo;

abstract class _Todo implements Store {
  _Todo({String task = '', String note})
      : this._(
          completed: false,
          id: _uuid.generateV4(),
          task: task,
          note: note,
        );

  _Todo._fromEntity(TodoEntity entity)
      : this._(
          completed: entity.complete,
          id: entity.id,
          note: entity.note,
          task: entity.task,
        );

  _Todo._({
    @required this.completed,
    @required this.id,
    @required this.task,
    this.note,
  })  : assert(completed != null),
        assert(id != null),
        assert(task != null);

  @observable
  bool completed;
  @observable
  String id;
  @observable
  String note;
  @observable
  String task;

  @action
  void onCompletedChange(bool value) => completed = value;

  TodoEntity toEntity() => TodoEntity(task, id, note, completed);
}
