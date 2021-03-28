import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo_app_flutter/model.dart';

class ViewModel {
  List<String> _todoItems = [];
  List<String> _completedItems = [];
  final LocalStorage storage = LocalStorage('todo storage');

  ViewModel() {
    _todoItems = storage.getItem('TodoItems') ?? [];
    _completedItems = storage.getItem('CompletedItems') ?? [];
  }

  List<Model> get items {
    return [
      ..._todoItems
          .map((string) => Model(type: TodoType.todo, content: string)),
      ..._completedItems
          .map((string) => Model(type: TodoType.completed, content: string)),
    ];
  }

  int get length {
    var count = 0;
    if (_todoItems != null) {
      count += _todoItems.length;
    }

    if (_completedItems != null) {
      count += _completedItems.length;
    }
    return count;
    return (_todoItems.length) + (_completedItems.length ?? 0);
  }

  void addTodo(String item) {
    if (item.isNotEmpty) {
      _todoItems.add(item);
      storage.setItem("todoItems", _todoItems);
    }
  }

  void clickOn(int index) {
    var item = items[index];
    switch (item.type) {
      case TodoType.todo:
        var removedTodo = _todoItems.removeAt(index);
        _completedItems.insert(0, removedTodo);
        storage.setItem("TodoItems", _todoItems);
        storage.setItem("CompletedItems", _completedItems);
        break;
      case TodoType.completed:
        _completedItems.removeAt(index - _todoItems.length);
        storage.setItem("CompletedItems", _completedItems);
        break;
    }
  }
}
