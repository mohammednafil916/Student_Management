import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';
import 'package:hive_learning/screens/add_student_screen.dart';
import 'package:hive_learning/screens/edit_student_screen.dart';
import 'package:hive_learning/screens/student_detail_screen.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Student> studentBox;

  final searchController = TextEditingController();
  List<Student> filteredStudents = [];

  @override
  void initState() {
    super.initState();

    studentBox = Hive.box<Student>("student_db");
    filteredStudents = studentBox.values.toList();
  }

  void searchStudent(String query) {
    final allStudents = studentBox.values.toList();

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
            studentBox.add(result);
            filteredStudents = studentBox.values.toList();
            setState(() {});
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

            Expanded(
              child: ListView.builder(
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
                                StudentDetailScreen(student: student),
                          ),
                        );
                      },
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(student.name),
                      subtitle: Text("Age: ${student.age} | ${student.course}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditStudentScreen(student: student),
                                ),
                              );
                              filteredStudents = studentBox.values.toList();
                              setState(() {});
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
                                        onPressed: () {
                                          student.delete();
                                          filteredStudents = studentBox.values.toList();
                                          setState(() {});
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
