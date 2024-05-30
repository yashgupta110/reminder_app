
class Reminder {
  String id;
  String title;
  String description;
  DateTime time;
  String priority; // High, Medium, Low

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
  });
}
