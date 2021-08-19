class Task {
  //A class object for mapping into the database
  late int id;
  late String title, description;
  Task({required this.id, required this.title, required this.description});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
