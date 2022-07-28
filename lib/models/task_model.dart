class TaskModel {
  late String id;
  late String title;
  String? body;
  late int dateInMilliseconds;
  late String startTime;
  late String endTime;
  late String reminder;
  late int color;
  late bool isComplected;
  late bool isFavorite;

  TaskModel({
    required this.id,
    required this.title,
    this.body,
    required this.dateInMilliseconds,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.color,
    this.isComplected = false,
    this.isFavorite = false,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    dateInMilliseconds = json['dateInMilliseconds'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    reminder = json['reminder'];
    color = json['color'];
    isComplected = json['isComplected'] == 'true' ? true : false;
    isFavorite = json['isFavorite'] == 'true' ? true : false;
  }

  static List<TaskModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<TaskModel> list = [];
    for(int i=0; i<jsonList.length; i++) {list.add(TaskModel.fromJson(jsonList[i]));}
    return list;
  }
}