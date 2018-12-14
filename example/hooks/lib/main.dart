// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hooks/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todos_repository_flutter/todos_repository_flutter.dart';

void main() {
  runApp(
    HooksApp(
      repository: TodosRepositoryFlutter(
        fileStorage: FileStorage(
          "hooks_app",
          getApplicationDocumentsDirectory,
        ),
        webClient: WebClient(),
      ),
    ),
  );
}
