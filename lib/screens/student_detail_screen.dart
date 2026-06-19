import 'package:flutter/material.dart';
import 'package:hive_learning/model/student_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Student Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 45),
                ),

                const SizedBox(height: 20),

                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("Name"),
                  subtitle: Text(student.name),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.cake),
                  title: const Text("Age"),
                  subtitle: Text(student.age.toString()),
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text("Course"),
                  subtitle: Text(student.course),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
