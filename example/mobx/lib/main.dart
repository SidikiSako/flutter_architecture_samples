import 'package:flutter/material.dart';
import 'package:mobx_flutter/src/app.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MobxApp(
      todosRepository: TodosRepositoryFlutter(
        fileStorage: FileStorage(
          'vanilla_app',
          getApplicationDocumentsDirectory,
        ),
        webClient: WebClient(),
      ),
    ));
