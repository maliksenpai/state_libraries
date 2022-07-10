import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_libraries/model/todo.dart';
import 'package:state_libraries/provider/provider.dart';
import 'package:state_libraries/riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:state_libraries/riverpod/riverpod.dart';

class RiverpodWrapper extends StatelessWidget {
  const RiverpodWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: RiverpodPage(),
    );
  }
}


class RiverpodPage extends ConsumerWidget {
  const RiverpodPage({Key? key}) : super(key: key);

  //widgetRef is an object that allows widgets to interact with provider
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoRiverpod = ref.watch(todoChangeNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Riverpod Page"),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return Center(
                child: todoRiverpod.todos.isEmpty
                    ? Container()
                    : Column(
                  children: todoRiverpod.todos.map((todo) {
                    return Card(
                      child: ListTile(
                        title: Text(todo.todo),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                child: InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(Icons.edit),
                                  ),
                                  onTap: () {
                                    providerDialog(
                                      todoRiverpod: todoRiverpod,
                                      context: context,
                                      currentTodo: todo,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Checkbox(
                              value: todo.finished,
                              onChanged: (value) {
                                todoRiverpod.updateTodo(
                                  todo.copyWith(finished: !todo.finished),
                                );
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                color: Colors.redAccent,
                                child: InkWell(
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    todoRiverpod.removeTodo(todo.id);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: todoRiverpod.loading ? CircularProgressIndicator(color: Colors.white,) : Icon(Icons.add),
          onPressed: todoRiverpod.loading ? null : () {
            providerDialog(todoRiverpod: todoRiverpod, context: context);
          },
        )
    );
  }
}

void providerDialog(
    {required TodoRiverpod todoRiverpod,
      required BuildContext context,
      Todo? currentTodo}) {
  TextEditingController textEditingController = TextEditingController();
  if (currentTodo != null) {
    textEditingController.text = currentTodo.todo;
  }
  String? error;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Add new Todo"),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: "Todo", errorText: error),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                if (textEditingController.text.isNotEmpty) {
                  setState(() {
                    error = null;
                  });
                  if (currentTodo != null) {
                    todoRiverpod.updateTodo(
                      currentTodo.copyWith(todo: textEditingController.text),
                    );
                  } else {
                    Todo newTodo = Todo(
                      id: Uuid().v4(),
                      todo: textEditingController.text,
                      finished: false,
                    );
                    todoRiverpod.addTodo(newTodo);
                  }
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    error = "Fill the todo";
                  });
                }
              },
            )
          ],
        );
      });
    },
  );
}
