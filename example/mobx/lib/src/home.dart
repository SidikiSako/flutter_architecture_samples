import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx_hooks/flutter_mobx_hooks.dart';
import 'package:mobx_flutter/src/localization.dart';
import 'package:mobx_flutter/src/todos.dart';
import 'package:provider/provider.dart';

enum HomeTab {
  todos,
  stats,
}

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tab = useState(HomeTab.todos);

    return Scaffold(
      appBar: AppBar(
        title: Text(MobxLocalizations.of(context).appTitle),
        actions: <Widget>[FilterButton(tab.value), const ExtraActionsButton()],
      ),
      body: tab.value == HomeTab.todos ? const TodosList() : const TodosStats(),
      floatingActionButton:
          const _AddTodoButton(key: ArchSampleKeys.addTodoFab),
      bottomNavigationBar: _BottomBar(
        onTabChanged: (newTab) => tab.value = newTab,
        tab: tab.value,
      ),
    );
  }
}

class _AddTodoButton extends StatelessWidget {
  const _AddTodoButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
      child: const Icon(Icons.add),
      tooltip: ArchSampleLocalizations.of(context).addTodo,
    );
  }
}

class TodosList extends HookWidget {
  const TodosList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final todos = useTodos();
    if (todos.loading) {
      return const Center(
        child: CircularProgressIndicator(key: ArchSampleKeys.todosLoading),
      );
    }

    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.todos.length,
      itemBuilder: (context, index) {
        final todo = todos.todos[index];
        return TodoItem(key: ArchSampleKeys.todoItem(todo.id), todo: todo);
      },
    );
  }
}

class TodoItem extends HookWidget {
  const TodoItem({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    useObserver();
    return Dismissible(
      key: key,
      // cancel the dismiss if failed to save
      onDismissed: (_) {
        Provider.of<Todos>(context).removeTodo(todo.id);
      },
      child: _TodoItem(
        id: todo.id,
        completed: todo.completed,
        note: todo.note,
        task: todo.task,
        onCheckboxChanged: todo.onCompletedChange,
      ),
    );
  }
}

// Pure UI, therefore doesn't use `useObserver`
class _TodoItem extends StatelessWidget {
  const _TodoItem({
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.task,
    @required this.id,
    @required this.completed,
    @required this.note,
    Key key,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final String task;
  final String id;
  final bool completed;
  final String note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        key: ArchSampleKeys.todoItemCheckbox(id),
        value: completed,
        onChanged: onCheckboxChanged,
      ),
      title: Text(
        task,
        key: ArchSampleKeys.todoItemTask(id),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        note,
        key: ArchSampleKeys.todoItemNote(id),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
      ),
    );
  }
}

class TodosStats extends HookWidget {
  const TodosStats({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FilterButton extends HookWidget {
  const FilterButton(this.tab, {Key key}) : super(key: key);

  final HomeTab tab;

  @override
  Widget build(BuildContext context) {
    final isActive = tab == HomeTab.todos;
    final todos = useTodos();

    return _Button(
      activeFilter: todos.filter,
      isActive: isActive,
      onSelected: todos.onFilterChanged,
    );
  }

  // We override == so that FilterButton rebuilds only when the tab changed
  @override
  bool operator ==(Object other) =>
      other is FilterButton && other.tab == tab && other.key == key;

  @override
  int get hashCode => hashValues(tab, key);
}

enum ExtraAction { toggleAllComplete, clearCompleted }

class ExtraActionsButton extends HookWidget {
  const ExtraActionsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = useTodos();

    return _ExtraActionsButton(
      hasCompletedTodos: todos.hasCompletedTodos,
      onAction: (action) {
        switch (action) {
          case ExtraAction.clearCompleted:
            todos.clearAll();
            return;
          case ExtraAction.toggleAllComplete:
            todos.completeAll();
            return;
        }
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    @required this.onTabChanged,
    @required this.tab,
    Key key,
  }) : super(key: key);

  final ValueChanged<HomeTab> onTabChanged;
  final HomeTab tab;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
          key: ArchSampleKeys.tabs,
          currentIndex: HomeTab.values.indexOf(tab),
          onTap: (index) => onTabChanged(HomeTab.values[index]),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.list, key: ArchSampleKeys.todoTab),
              title: Text(ArchSampleLocalizations.of(context).todos),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.show_chart, key: ArchSampleKeys.statsTab),
              title: Text(ArchSampleLocalizations.of(context).stats),
            ),
          ]);
}

// Copied from vanilla example
// Nothing but UI
class _ExtraActionsButton extends StatelessWidget {
  const _ExtraActionsButton({
    @required this.onAction,
    @required this.hasCompletedTodos,
    Key key,
  }) : super(key: key);

  final ValueChanged<ExtraAction> onAction;
  final bool hasCompletedTodos;

  @override
  Widget build(BuildContext context) => PopupMenuButton<ExtraAction>(
        key: ArchSampleKeys.extraActionsButton,
        onSelected: onAction,
        itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                key: ArchSampleKeys.toggleAll,
                value: ExtraAction.toggleAllComplete,
                child: Text(hasCompletedTodos
                    ? ArchSampleLocalizations.of(context).markAllIncomplete
                    : ArchSampleLocalizations.of(context).markAllComplete),
              ),
              PopupMenuItem<ExtraAction>(
                key: ArchSampleKeys.clearCompleted,
                value: ExtraAction.clearCompleted,
                child: Text(ArchSampleLocalizations.of(context).clearCompleted),
              ),
            ],
      );
}

// Copied from vanilla example
// It is nothing but UI logic
class _Button extends StatelessWidget {
  const _Button({
    @required this.onSelected,
    @required this.activeFilter,
    @required this.isActive,
    Key key,
  }) : super(key: key);

  final bool isActive;
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    return AnimatedOpacity(
      opacity: isActive ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: IgnorePointer(
        ignoring: !isActive,
        ignoringSemantics: !isActive,
        child: PopupMenuButton<VisibilityFilter>(
          key: ArchSampleKeys.filterButton,
          tooltip: ArchSampleLocalizations.of(context).filterTodos,
          onSelected: onSelected,
          itemBuilder: (BuildContext context) =>
              <PopupMenuItem<VisibilityFilter>>[
                PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.allFilter,
                  value: VisibilityFilter.all,
                  child: Text(
                    ArchSampleLocalizations.of(context).showAll,
                    style: activeFilter == VisibilityFilter.all
                        ? activeStyle
                        : defaultStyle,
                  ),
                ),
                PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.activeFilter,
                  value: VisibilityFilter.active,
                  child: Text(
                    ArchSampleLocalizations.of(context).showActive,
                    style: activeFilter == VisibilityFilter.active
                        ? activeStyle
                        : defaultStyle,
                  ),
                ),
                PopupMenuItem<VisibilityFilter>(
                  key: ArchSampleKeys.completedFilter,
                  value: VisibilityFilter.completed,
                  child: Text(
                    ArchSampleLocalizations.of(context).showCompleted,
                    style: activeFilter == VisibilityFilter.completed
                        ? activeStyle
                        : defaultStyle,
                  ),
                ),
              ],
          icon: const Icon(Icons.filter_list),
        ),
      ),
    );
  }
}
