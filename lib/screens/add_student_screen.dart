import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Add Student",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight(500)),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Student Name"),
              controller: nameController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Student Age"),
              controller: ageController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Student Course"),
              controller: courseController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final student = Student(
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  course: courseController.text,
                );
                Navigator.pop(context,student);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
