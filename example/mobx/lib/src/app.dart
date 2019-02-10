import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:mobx_flutter/src/add_todo.dart';
import 'package:mobx_flutter/src/home.dart';
import 'package:mobx_flutter/src/localization.dart';
import 'package:mobx_flutter/src/todos.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:provider/provider.dart';

class MobxApp extends StatelessWidget {
  const MobxApp({Key key, this.todosRepository}) : super(key: key);

  final TodosRepository todosRepository;

  @override
  Widget build(BuildContext context) => StatefulProvider<Todos>(
        valueBuilder: (_) => Todos(todosRepository)..loadTodos(),
        child: MaterialApp(
          onGenerateTitle: (context) => MobxLocalizations.of(context).appTitle,
          theme: ArchSampleTheme.theme,
          localizationsDelegates: const [
            ArchSampleLocalizationsDelegate(),
            MobxLocalizationsDelegate(),
          ],
          routes: {
            ArchSampleRoutes.addTodo: (context) =>
                const AddTodo(key: ArchSampleKeys.addTodoScreen),
          },
          home: const Home(key: ArchSampleKeys.homeScreen),
        ),
      );
}
