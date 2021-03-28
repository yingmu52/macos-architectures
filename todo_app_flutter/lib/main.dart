import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoListView(viewModel: ViewModel()));
  }
}

class TodoListView extends StatefulWidget {
  TodoListView({Key key, this.viewModel}) : super(key: key);
  final ViewModel viewModel;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  List<Widget> get listChildren {
    return widget.viewModel.items.map<GestureDetector>((item) {
      var c = Container(
        decoration: BoxDecoration(
          color: item.type == TodoType.todo ? Colors.indigo : Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.content,
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 2,
            ),
          ),
          margin: EdgeInsets.all(item.type == TodoType.todo ? 12 : 10),
        ),
      );
      return GestureDetector(
        child: c,
        onDoubleTap: () {
          print("${item.content} tapped");
        },
      );
    }).toList();
  }

  Container get inputTextView {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.all(8),
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none, labelText: 'Enter your username'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: listChildren,
            ),
          ),
          Divider(),
          inputTextView
        ],
      ),
    );
  }
}

enum TodoType {
  todo,
  completed,
}

class Model {
  final TodoType type;
  final String content;

  Model({this.type, this.content});
}

class ViewModel {
  List<String> _todoItems = [
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf12312312312312312",
    // "aadfadfadfafadfadfadfafadfadfadfafadfadfadfafadfadfadfaf",
    "2",
    "3",
  ];
  List<String> _completedItems = ["4", "5", "6"];

  List<Model> get items {
    return [
      ..._todoItems
          .map((string) => Model(type: TodoType.todo, content: string)),
      ..._completedItems
          .map((string) => Model(type: TodoType.completed, content: string)),
    ];
  }

  ViewModel();

  void addTodo(String item) {
    _todoItems.add(item);
  }
}
