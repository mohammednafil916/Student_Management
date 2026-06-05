import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';
import 'package:hive_learning/screens/add_student_screen.dart';
import 'package:hive_learning/screens/edit_student_screen.dart';
import 'package:hive_learning/screens/student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Students = [
    Student(name: "Nafil", age: 21, course: "Flutter"),
    Student(name: "Shifin", age: 24, course: "Mern"),
    Student(name: "Anees", age: 23, course: "Python"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Student Management",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight(500)),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
          if (result != null) {
            Students.add(result);
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: Students.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentDetailScreen(student: Students[index]),
                  ),
                );
              },
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(Students[index].name),
              subtitle: Text(
                "Age: ${Students[index].age} | ${Students[index].course}",
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
                              EditStudentScreen(student: Students[index]),
                        ),
                      );
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
                                  Students.removeAt(index);
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
    );
  }
}
