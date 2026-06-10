import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';
import 'package:hive_learning/data/student_repository.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({super.key, required this.student});
  final Student student;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.student.name;
    ageController.text = widget.student.age.toString();
    courseController.text = widget.student.course;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Edit Student",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight(500),
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Student Name"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Student Age"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: courseController,
              decoration: InputDecoration(labelText: "Student Course"),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final oldName = widget.student.name;
                final oldAge = widget.student.age;
                final oldCourse = widget.student.course;

                widget.student.name = nameController.text;
                widget.student.age = int.parse(ageController.text);
                widget.student.course = courseController.text;

                bool updated = await StudentRepository().updateStudent(widget.student,);

                if (updated) {
                  Navigator.pop(context);
                } else {
                  widget.student.name = oldName;
                  widget.student.age = oldAge;
                  widget.student.course = oldCourse;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Student already exists")),
                  );
                }
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
