import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/components/database_helper.dart';
import 'package:todoapp/components/size_config.dart';
import 'package:todoapp/components/widgets.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/screens/homePage.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  final bool add;
  final int length;
  const TaskPage({
    required this.task,
    required this.add,
    required this.length,
  });
  //Add task page
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var _dbHelper = DatabaseHelper();
  int lengthTodo = 0;
  //to get the ids for todos
  void lengthOfTodo() async {
    lengthTodo = await _dbHelper.getTodoLength();
  }

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  TextEditingController _textController = TextEditingController();
  String _firstTimeTitle = "";
  String _firstTimeDescription = "";
  @override
  void initState() {
    super.initState();
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyBoardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    lengthOfTodo();
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: defaultSize * .65,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(defaultSize),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              defaultSize * 2.5,
                            ),
                            splashColor: Color(0xFFFE3577),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultSize * 2.2,
                                vertical: defaultSize * 2.5,
                              ),
                              child: Image.asset(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: defaultSize * .7,
                        ),
                        Expanded(
                          child: Padding(
                              padding:
                                  EdgeInsets.only(right: defaultSize * 2.4),
                              child: TextField(
                                focusNode: _titleFocus,
                                onSubmitted: (value) async {
                                  if (value != "") {
                                    if (widget.add == true) {
                                      _firstTimeTitle = value;
                                      var _newTask = Task(
                                        title: value,
                                        description: _firstTimeDescription,
                                        id: widget.length + 1,
                                      );
                                      await _dbHelper.insertTask(_newTask);
                                    } else {
                                      widget.task.title = value;
                                      await _dbHelper.updateTaskTitle(
                                          widget.task.id, value);
                                    }
                                  }
                                  _descriptionFocus.requestFocus();
                                },
                                controller: TextEditingController(
                                    text: widget.add == true
                                        ? _firstTimeTitle
                                        : widget.task.title),
                                decoration: InputDecoration(
                                  hintText: widget.add == true
                                      ? 'Enter Task '
                                      : 'Edit Task ',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: defaultSize * 4.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF211551),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.add == true && _firstTimeTitle == ""
                        ? false
                        : true,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: defaultSize * .5),
                        child: TextField(
                          focusNode: _descriptionFocus,
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (widget.add == true) {
                                _firstTimeDescription = value;
                                await _dbHelper.updateTaskDescription(
                                    widget.length + 1, value);
                              } else {
                                widget.task.description = value;
                                await _dbHelper.updateTaskDescription(
                                    widget.task.id, value);
                              }
                            }
                            _todoFocus.requestFocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Description',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: defaultSize * 2.4),
                          ),
                          controller: TextEditingController(
                              text: widget.add == true
                                  ? _firstTimeDescription
                                  : widget.task.description),
                          style: TextStyle(
                            fontSize: defaultSize * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551),
                          ),
                        )),
                  ),
                  Visibility(
                    visible: !widget.add,
                    child: FutureBuilder<List<Todo>>(
                      initialData: [],
                      future: _dbHelper.getTodo(widget.task.id),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (widget.add == true) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data![index].id, 0);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data![index].id,
                                        snapshot.data![index].isDone == 0
                                            ? 1
                                            : 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  defaultSize: defaultSize,
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: !widget.add,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultSize * 2.4),
                      child: Row(
                        children: [
                          Container(
                            width: defaultSize * 2,
                            height: defaultSize * 2,
                            margin: EdgeInsets.only(
                              right: defaultSize * 1.6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF86829D),
                                  width: defaultSize * .15),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                defaultSize * .6,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/check_icon.png',
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              controller: _textController,
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                lengthOfTodo();
                                if (value != "") {
                                  var _newTodo = Todo(
                                    isDone: 0,
                                    taskId: widget.add == true
                                        ? widget.length + 1
                                        : widget.task.id,
                                    title: value,
                                    id: lengthTodo + 1,
                                  );
                                  await _dbHelper.insertTodo(_newTodo);
                                }
                                _textController.clear();
                                _todoFocus.requestFocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter ToDo',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: defaultSize * 2,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !widget.add,
                child: Positioned(
                  right: defaultSize * 2,
                  bottom: defaultSize * 2,
                  child: Visibility(
                    visible: !keyBoardOpen,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await _dbHelper.deleteTask(widget.task.id);
                        setState(() {});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        ).then(
                          (value) {
                            setState(() {});
                          },
                        );
                      },
                      child: Container(
                        height: defaultSize * 6,
                        width: defaultSize * 6,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE3577),
                          borderRadius: BorderRadius.circular(
                            defaultSize * 2,
                          ),
                        ),
                        child: Image.asset('assets/images/delete_icon.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
