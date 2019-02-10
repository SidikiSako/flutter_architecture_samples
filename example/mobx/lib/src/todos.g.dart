// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$Todos on _Todos, Store {
  Computed<bool> _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??=
          Computed<bool>(() => super.hasCompletedTodos))
      .value;

  final _$filterAtom = Atom(name: '_Todos.filter');

  @override
  VisibilityFilter get filter {
    _$filterAtom.reportObserved();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    mainContext.checkIfStateModificationsAreAllowed(_$filterAtom);
    super.filter = value;
    _$filterAtom.reportChanged();
  }

  final _$loadingAtom = Atom(name: '_Todos.loading');

  @override
  bool get loading {
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    mainContext.checkIfStateModificationsAreAllowed(_$loadingAtom);
    super.loading = value;
    _$loadingAtom.reportChanged();
  }

  final _$savingAtom = Atom(name: '_Todos.saving');

  @override
  bool get saving {
    _$savingAtom.reportObserved();
    return super.saving;
  }

  @override
  set saving(bool value) {
    mainContext.checkIfStateModificationsAreAllowed(_$savingAtom);
    super.saving = value;
    _$savingAtom.reportChanged();
  }

  final _$todosAtom = Atom(name: '_Todos.todos');

  @override
  List<Todo> get todos {
    _$todosAtom.reportObserved();
    return super.todos;
  }

  @override
  set todos(List<Todo> value) {
    mainContext.checkIfStateModificationsAreAllowed(_$todosAtom);
    super.todos = value;
    _$todosAtom.reportChanged();
  }

  final _$_trySaveAsyncAction = AsyncAction('_trySave');

  @override
  Future<void> _trySave(Iterable<Todo> newTodos) {
    return _$_trySaveAsyncAction.run(() => super._trySave(newTodos));
  }

  final _$loadTodosAsyncAction = AsyncAction('loadTodos');

  @override
  Future<void> loadTodos() {
    return _$loadTodosAsyncAction.run(() => super.loadTodos());
  }

  final _$_TodosActionController = ActionController(name: '_Todos');

  @override
  Future<void> addTodo(Todo todo) {
    final _$actionInfo = _$_TodosActionController.startAction();
    try {
      return super.addTodo(todo);
    } finally {
      _$_TodosActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> removeTodo(String id) {
    final _$actionInfo = _$_TodosActionController.startAction();
    try {
      return super.removeTodo(id);
    } finally {
      _$_TodosActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onFilterChanged(VisibilityFilter filter) {
    final _$actionInfo = _$_TodosActionController.startAction();
    try {
      return super.onFilterChanged(filter);
    } finally {
      _$_TodosActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll() {
    final _$actionInfo = _$_TodosActionController.startAction();
    try {
      return super.clearAll();
    } finally {
      _$_TodosActionController.endAction(_$actionInfo);
    }
  }

  @override
  void completeAll() {
    final _$actionInfo = _$_TodosActionController.startAction();
    try {
      return super.completeAll();
    } finally {
      _$_TodosActionController.endAction(_$actionInfo);
    }
  }
}

mixin _$Todo on _Todo, Store {
  final _$completedAtom = Atom(name: '_Todo.completed');

  @override
  bool get completed {
    _$completedAtom.reportObserved();
    return super.completed;
  }

  @override
  set completed(bool value) {
    mainContext.checkIfStateModificationsAreAllowed(_$completedAtom);
    super.completed = value;
    _$completedAtom.reportChanged();
  }

  final _$idAtom = Atom(name: '_Todo.id');

  @override
  String get id {
    _$idAtom.reportObserved();
    return super.id;
  }

  @override
  set id(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$idAtom);
    super.id = value;
    _$idAtom.reportChanged();
  }

  final _$noteAtom = Atom(name: '_Todo.note');

  @override
  String get note {
    _$noteAtom.reportObserved();
    return super.note;
  }

  @override
  set note(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$noteAtom);
    super.note = value;
    _$noteAtom.reportChanged();
  }

  final _$taskAtom = Atom(name: '_Todo.task');

  @override
  String get task {
    _$taskAtom.reportObserved();
    return super.task;
  }

  @override
  set task(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$taskAtom);
    super.task = value;
    _$taskAtom.reportChanged();
  }

  final _$_TodoActionController = ActionController(name: '_Todo');

  @override
  void onCompletedChange(bool value) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.onCompletedChange(value);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }
}
