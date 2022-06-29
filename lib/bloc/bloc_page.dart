import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_libraries/bloc/bloc.dart';
import 'package:state_libraries/bloc/bloc_event.dart';
import 'package:state_libraries/bloc/bloc_state.dart';
import 'package:state_libraries/model/todo.dart';
import 'package:uuid/uuid.dart';

class BlocWrapper extends StatelessWidget {
  const BlocWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => TodoBloc(),
      child: BlocPage(),
    );
  }
}


class BlocPage extends StatelessWidget {
  const BlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoBloc todoBloc = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Bloc Page"),),
      body: SafeArea(
        child: Center(
          child: BlocBuilder(
            bloc: todoBloc,
            builder: (context, state) {
              if(state is UpdatedTodos || state is LoadingTodos){
                return Column(
                    children: todoBloc.todos.map((todo) {
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
                                      todoDialog(todoBloc: todoBloc, context: context, currentTodo: todo);
                                    },
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: todo.finished,
                                onChanged: (value) {
                                  todoBloc.add(UpdateTodo(todo: todo.copyWith(finished: !todo.finished)));
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Material(
                                  color: Colors.redAccent,
                                  child: InkWell(
                                    child: const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(Icons.delete, color: Colors.white,),
                                    ),
                                    onTap: () {
                                      todoBloc.add(RemoveTodo(id: todo.id));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList()
                );
              } else if (state is TodoInitState) {
                return Text("Init State");
              } else {
                return Container();
              }
            }
          ),
        ),
      ),
      floatingActionButton: BlocBuilder(
        bloc: todoBloc,
        builder: (context, state) {
          return FloatingActionButton(
            child: state is LoadingTodos ? CircularProgressIndicator(color: Colors.white,) : Icon(Icons.add),
            onPressed: state is LoadingTodos ? null : () {
              todoDialog(todoBloc: todoBloc, context: context);
            },
          );
        }
      ),
    );
  }
}

void todoDialog({required TodoBloc todoBloc, required BuildContext context, Todo? currentTodo}){
  TextEditingController textEditingController = TextEditingController();
  if(currentTodo != null){
    textEditingController.text = currentTodo.todo;
  }
  String? error;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Add new Todo"),
            content: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: "Todo",
                errorText: error
              ),
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
                onPressed: (){
                  if(textEditingController.text.isNotEmpty){
                    setState((){
                      error = null;
                    });
                    if(currentTodo != null){
                      todoBloc.add(UpdateTodo(todo: currentTodo.copyWith(todo: textEditingController.text)));
                    }else{
                      Todo newTodo = Todo(id: Uuid().v4(), todo: textEditingController.text, finished: false);
                      todoBloc.add(AddTodo(todo: newTodo));
                    }
                    Navigator.of(context).pop();
                  }else{
                    setState((){
                      error = "Fill the todo";
                    });
                  }
                },
              )
            ],
          );
        });
    }
  );
}
