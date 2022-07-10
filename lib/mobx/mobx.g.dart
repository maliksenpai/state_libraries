// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MobxTodo on _MobxTodo, Store {
  late final _$todosAtom = Atom(name: '_MobxTodo.todos', context: context);

  @override
  List<Todo> get todos {
    _$todosAtom.reportRead();
    return super.todos;
  }

  @override
  set todos(List<Todo> value) {
    _$todosAtom.reportWrite(value, super.todos, () {
      super.todos = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_MobxTodo.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$addTodoAsyncAction =
      AsyncAction('_MobxTodo.addTodo', context: context);

  @override
  Future<dynamic> addTodo(Todo todo) {
    return _$addTodoAsyncAction.run(() => super.addTodo(todo));
  }

  late final _$updateTodoAsyncAction =
      AsyncAction('_MobxTodo.updateTodo', context: context);

  @override
  Future<dynamic> updateTodo(Todo todo) {
    return _$updateTodoAsyncAction.run(() => super.updateTodo(todo));
  }

  late final _$removeTodoAsyncAction =
      AsyncAction('_MobxTodo.removeTodo', context: context);

  @override
  Future<dynamic> removeTodo(String id) {
    return _$removeTodoAsyncAction.run(() => super.removeTodo(id));
  }

  @override
  String toString() {
    return '''
todos: ${todos},
loading: ${loading}
    ''';
  }
}
