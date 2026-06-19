import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';
import 'package:hive_learning/data/student_repository.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({
    super.key,
    required this.student,
  });

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
        title: const Text(
          "Edit Student",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Student Age",
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: "Student Course",
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final oldName = widget.student.name;
                  final oldAge = widget.student.age;
                  final oldCourse = widget.student.course;

                  widget.student.name = nameController.text;
                  widget.student.age =
                      int.parse(ageController.text);
                  widget.student.course =
                      courseController.text;

                  bool updated = await StudentRepository()
                      .updateStudent(widget.student);

                  if (updated) {
                    Navigator.pop(context);
                  } else {
                    widget.student.name = oldName;
                    widget.student.age = oldAge;
                    widget.student.course = oldCourse;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Student already exists",
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Update Student"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}