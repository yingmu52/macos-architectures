
enum TodoType {
  todo,
  completed,
}

class Model {
  final TodoType type;
  final String content;

  Model({this.type, this.content});
}