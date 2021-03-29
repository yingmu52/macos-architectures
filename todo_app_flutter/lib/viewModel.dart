import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/model.dart';

class ViewModel {
  List<String> _todoItems = [];
  List<String> _completedItems = [];
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future loadData() async {
    final pref = await _pref;
    _todoItems = pref.getStringList('TodoItems');
    _completedItems = pref.getStringList('CompletedItems');
    print(_todoItems);
    print(_completedItems);
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
  }

  Future addTodo(String item) async {
    if (item.isNotEmpty) {
      _todoItems.add(item);

      var pref = await _pref;
      pref.setStringList('TodoItems', _todoItems);
    }
  }

  Future clickOn(int index) async {
    var item = items[index];

    var pref = await _pref;

    switch (item.type) {
      case TodoType.todo:
        var removedTodo = _todoItems.removeAt(index);
        _completedItems.insert(0, removedTodo);

        await Future.wait([
          pref.setStringList('TodoItems', _todoItems),
          pref.setStringList('CompletedItems', _completedItems),
        ]);
        break;

      case TodoType.completed:
        _completedItems.removeAt(index - _todoItems.length);
        await pref.setStringList('CompletedItems', _completedItems);
        break;
    }
  }
}
