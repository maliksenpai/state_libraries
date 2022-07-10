import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_libraries/get/get.dart';
import 'package:state_libraries/model/todo.dart';
import 'package:uuid/uuid.dart';

class GetWrapper extends StatelessWidget {
  const GetWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      getPages: [GetPage(name: "/home", page: () => GetxPage())],
      home: GetxPage(),
    );
  }
}

class GetxPage extends StatelessWidget {
  const GetxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetTodo getTodo = Get.put(GetTodo());
    return Scaffold(
      appBar: AppBar(
        title: Text("Getx Page"),
      ),
      body: SafeArea(
        child: Obx(() {
          return Center(
            child: getTodo.todos.isEmpty
                ? Container()
                : Column(
                    children: getTodo.todos.map((todo) {
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
                                      getDialog(
                                        getTodo: getTodo,
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
                                  getTodo.updateTodo(
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
                                      getTodo.removeTodo(todo.id);
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
      floatingActionButton: Obx(
        () {
          return FloatingActionButton(
            child: getTodo.loading.value
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Icon(Icons.add),
            onPressed: getTodo.loading.value
                ? null
                : () {
                    getDialog(getTodo: getTodo, context: context);
                  },
          );
        },
      ),
    );
  }
}

void getDialog(
    {required GetTodo getTodo,
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
                    getTodo.updateTodo(
                      currentTodo.copyWith(todo: textEditingController.text),
                    );
                  } else {
                    Todo newTodo = Todo(
                      id: Uuid().v4(),
                      todo: textEditingController.text,
                      finished: false,
                    );
                    getTodo.addTodo(newTodo);
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
