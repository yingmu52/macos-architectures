import 'package:flutter/material.dart';
import 'package:todo_app_flutter/model.dart';

class ViewModel {
  List<String> _todoItems = [];
  List<String> _completedItems = [];

  ViewModel();

  List<Model> get items {
    return [
      ..._todoItems
          .map((string) => Model(type: TodoType.todo, content: string)),
      ..._completedItems
          .map((string) => Model(type: TodoType.completed, content: string)),
    ];
  }

  int get length {
    return _todoItems.length + _completedItems.length;
  }

  void addTodo(String item) {
    if (item.isNotEmpty) {
      _todoItems.add(item);
    }
  }

  void clickOn(int index) {
    var item = items[index];
    switch (item.type) {
      case TodoType.todo:
        var removedTodo = _todoItems.removeAt(index);
        _completedItems.insert(0, removedTodo);
        break;
      case TodoType.completed:
        _completedItems.removeAt(index - _todoItems.length);
        break;
    }
  }
}
