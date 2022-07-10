import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:state_libraries/mobx/mobx.dart';
import 'package:state_libraries/model/todo.dart';
import 'package:uuid/uuid.dart';

class MobxPage extends StatelessWidget {
  const MobxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MobxTodo mobxTodo = MobxTodo();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mobx Page"),
      ),
      body: SafeArea(
        child: Observer(builder: (_) {
          return Center(
            child: mobxTodo.todos.isEmpty
                ? Container()
                : Column(
                    children: mobxTodo.todos.map((todo) {
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
                                      mobxDialog(
                                        mobxTodo: mobxTodo,
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
                                  mobxTodo.updateTodo(
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
                                      mobxTodo.removeTodo(todo.id);
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
        }),
      ),
      floatingActionButton: Observer(builder: (_) {
        print(mobxTodo);
        return FloatingActionButton(
          child: mobxTodo.loading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(Icons.add),
          onPressed: mobxTodo.loading
              ? null
              : () {
                  mobxDialog(mobxTodo: mobxTodo, context: context);
                },
        );
      }),
    );
  }
}

void mobxDialog(
    {required MobxTodo mobxTodo,
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
                    mobxTodo.updateTodo(
                      currentTodo.copyWith(todo: textEditingController.text),
                    );
                  } else {
                    Todo newTodo = Todo(
                      id: Uuid().v4(),
                      todo: textEditingController.text,
                      finished: false,
                    );
                    mobxTodo.addTodo(newTodo);
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
