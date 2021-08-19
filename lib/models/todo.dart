class Todo  {
   int id,isDone,taskId;
   String title;

  Todo({required this.id,required this.isDone,required this.title,required this.taskId});
  Map<String,dynamic>toMap(){
    return{
      'id':id,
      'taskId':taskId,
      'title':title,
      'isDone':isDone,
    };
  }
}