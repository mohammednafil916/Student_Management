import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';
import 'package:hive_learning/screens/add_student_screen.dart';
import 'package:hive_learning/screens/edit_student_screen.dart';
import 'package:hive_learning/screens/student_detail_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learning/data/student_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Student> studentBox;

  final searchController = TextEditingController();
  List<Student> filteredStudents = [];

  late Future<void> studentsFuture;

  void refreshStudents() {
    searchStudent(searchController.text);
  }

  Future<void> loadStudents() async {
    await Future.delayed(Duration(seconds: 2));
  }

  final Stream<int> counterStream = Stream.periodic(
    Duration(seconds: 1),
    (count) => count,
  );

  final repository = StudentRepository();

  @override
  void initState() {
    super.initState();

    studentBox = Hive.box<Student>("student_db");
    filteredStudents = repository.getAllStudents();

    studentsFuture = loadStudents();
  }

  void searchStudent(String query) {
    final allStudents = repository.getAllStudents();

    setState(() {
      filteredStudents = allStudents.where((student) {
        return student.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Student List",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight(500),
            color: Colors.white,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );

          if (result != null) {
            bool added = await repository.addStudent(result);

            if (added) {
              refreshStudents();
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Student already exists")));
            }
          }
        },
        child: Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Student",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchStudent,
            ),

            SizedBox(height: 10),

            ValueListenableBuilder(
              valueListenable: studentBox.listenable(),
              builder: (context, Box<Student> box, _) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Total Students: ${box.length}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: studentBox.listenable(),
                      builder: (context, Box<Student> box, _) {
                        return FutureBuilder(
                          future: studentsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return ListView.builder(
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student = filteredStudents[index];

                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StudentDetailScreen(
                                                student: student,
                                              ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text(student.name),
                                    subtitle: Text(
                                      "Age: ${student.age} | ${student.course}",
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditStudentScreen(
                                                      student: student,
                                                    ),
                                              ),
                                            );
                                            refreshStudents();
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Delete Student"),
                                                  content: Text(
                                                    "Are you sure you want to delete this student?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await repository
                                                            .deleteStudent(
                                                              student,
                                                            );
                                                        refreshStudents();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  StreamBuilder<int>(
                    stream: counterStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Counter: 0");
                      }

                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Live Counter: ${snapshot.data}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
