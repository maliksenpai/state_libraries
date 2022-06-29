import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_libraries/model/todo.dart';
import 'package:state_libraries/provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TodoProvider()),
      ],
      child: const ProviderPage(),
    );
  }
}

class ProviderPage extends StatelessWidget {
  const ProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todoProvider = context.watch<TodoProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Provider Page"),
        ),
        body: SafeArea(
          child: Center(
            child: todoProvider.todos.isEmpty
                ? Container()
                : Column(
                    children: todoProvider.todos.map((todo) {
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
                                        todoProvider: todoProvider,
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
                                  todoProvider.updateTodo(
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
                                      todoProvider.removeTodo(todo.id);
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: todoProvider.loading ? CircularProgressIndicator(color: Colors.white,) : Icon(Icons.add),
          onPressed: todoProvider.loading ? null : () {
            providerDialog(todoProvider: todoProvider, context: context);
          },
        )
    );
  }
}

void providerDialog(
    {required TodoProvider todoProvider,
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
                    todoProvider.updateTodo(
                      currentTodo.copyWith(todo: textEditingController.text),
                    );
                  } else {
                    Todo newTodo = Todo(
                      id: Uuid().v4(),
                      todo: textEditingController.text,
                      finished: false,
                    );
                    todoProvider.addTodo(newTodo);
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
