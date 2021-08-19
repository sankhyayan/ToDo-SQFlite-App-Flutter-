import 'package:flutter/material.dart';
import 'package:todoapp/components/database_helper.dart';
import 'package:todoapp/components/size_config.dart';
import 'package:todoapp/components/widgets.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/screens/task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    int length = 0;
    final Task task = Task(
      id: 0,
      title: "",
      description: "",
    );
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2.4,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F6),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: defaultSize * 2),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  SizedBox(
                    height: defaultSize * 2,
                  ),
                  Expanded(
                    child: FutureBuilder<List<Task>>(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        length = snapshot.data!.length==0?0:snapshot.data![snapshot.data!.length-1].id;
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                        task: snapshot.data![index],
                                        add: false,
                                        length: length,
                                      ),
                                    ),
                                  );
                                },
                                child: TaskCard(
                                    defaultSize: defaultSize,
                                    title: snapshot.data![index].title,
                                    description:
                                        snapshot.data![index].description),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: defaultSize * 2,
                right: defaultSize * 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPage(
                          task: task,
                          add: true,
                          length: length,

                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: defaultSize * 6,
                    width: defaultSize * 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(
                        defaultSize * 2,
                      ),
                    ),
                    child: Image.asset('assets/images/add_icon.png'),
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
