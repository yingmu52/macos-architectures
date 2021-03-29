import 'package:flutter/material.dart';
import 'package:todo_app_flutter/model.dart';
import 'package:todo_app_flutter/viewModel.dart';

class TodoListView extends StatefulWidget {
  TodoListView({Key key, this.viewModel}) : super(key: key);
  final ViewModel viewModel;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  var _textEditingController = TextEditingController();
  var _textFocusMode = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    _textFocusMode.dispose();
    super.dispose();
  }

  List<Widget> get listChildren {
    List<Widget> list = [];
    for (var i = 0; i < widget.viewModel.length; i++) {
      var item = widget.viewModel.items[i];
      var container = Container(
        decoration: BoxDecoration(
          color: item.type == TodoType.todo ? Colors.indigo : Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Container(
          child: Row(
            children: [
              Icon(
                item.type == TodoType.todo ? Icons.radio_button_unchecked: Icons.check_circle,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
             ),
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  item.content,
                  style: TextStyle(
                    decoration: item.type == TodoType.todo
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.all(10),
          height: item.type == TodoType.todo ? 40 : 35,
        ),
      );
      var gesture = GestureDetector(
        child: container,
        onDoubleTap: () => {setState(() => widget.viewModel.clickOn(i))},
      );
      list.add(gesture);
    }
    return list;
  }

  Container get inputTextView {
    return Container(
      color: Colors.white,
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
            focusNode: _textFocusMode,
            autofocus: true,
            controller: _textEditingController,
            textInputAction: TextInputAction.newline,
            // detect enter
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Add new todo here',
            ),
            onSubmitted: (text) {
              setState(() {
                widget.viewModel.addTodo(_textEditingController.text);
              });
              _textEditingController.text = ""; // clear text field
              _textFocusMode.requestFocus(); // refocus textfield after onSubmit
            },
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
