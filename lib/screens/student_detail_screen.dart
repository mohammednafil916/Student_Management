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
        title: Text(
          "Student Details",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                "Name: ${student.name}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                "Age: ${student.age}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                "Course: ${student.course}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
