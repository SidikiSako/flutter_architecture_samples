import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx_flutter/src/todos.dart';
import 'package:provider/provider.dart';

class AddTodo extends HookWidget {
  const AddTodo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoForm(
      title: Text(ArchSampleLocalizations.of(context).addTodo),
    );
  }
}

class TodoForm extends HookWidget {
  const TodoForm({
    @required this.title,
    Key key,
  }) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    final taskController = useTextEditingController();
    final noteController = useTextEditingController();
    return _TodoForm(
      title: title,
      taskController: taskController,
      taskValidator: (val) => val.trim().isEmpty
          ? ArchSampleLocalizations.of(context).emptyTodoError
          : null,
      noteController: noteController,
      submitIcon: const Icon(Icons.add),
      submitButtonKey: ArchSampleKeys.saveNewTodo,
      submitTooltip: ArchSampleLocalizations.of(context).addTodo,
      onValidate: () async {
        await Provider.of<Todos>(context).addTodo(Todo(
          note: noteController.value.text,
          task: taskController.value.text,
        ));
        Navigator.pop(context);
      },
    );
  }
}

typedef Validator = String Function(String value);

class _TodoForm extends StatelessWidget {
  const _TodoForm({
    @required this.title,
    @required this.submitIcon,
    this.taskController,
    this.noteController,
    this.taskValidator,
    this.noteValidator,
    this.submitButtonKey,
    this.submitTooltip,
    this.onValidate,
    Key key,
  }) : super(key: key);

  final Key submitButtonKey;
  final Widget title;
  final TextEditingController taskController;
  final Validator taskValidator;
  final TextEditingController noteController;
  final Validator noteValidator;
  final String submitTooltip;
  final Widget submitIcon;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) => Form(
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(title: title),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: taskController,
                      key: ArchSampleKeys.taskField,
                      autofocus: true,
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                          hintText:
                              ArchSampleLocalizations.of(context).newTodoHint),
                      validator: taskValidator,
                    ),
                    TextFormField(
                      key: ArchSampleKeys.noteField,
                      controller: noteController,
                      maxLines: 10,
                      style: Theme.of(context).textTheme.subhead,
                      decoration: InputDecoration(
                        hintText: ArchSampleLocalizations.of(context).notesHint,
                      ),
                      validator: noteValidator,
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  key: submitButtonKey,
                  tooltip: submitTooltip,
                  child: submitIcon,
                  onPressed: () {
                    final form = Form.of(context);
                    if (form.validate()) {
                      form.save();
                      onValidate();
                    }
                  }),
            );
          },
        ),
      );
}

TextEditingController useTextEditingController([String intialValue]) {
  final controller =
      useMemoized(() => TextEditingController(text: intialValue));
  useEffect(() => controller.dispose, <dynamic>[controller]);
  return controller;
}
