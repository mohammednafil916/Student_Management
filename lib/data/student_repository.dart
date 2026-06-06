import 'package:hive/hive.dart';
import 'package:hive_learning/model/student_model.dart';

class StudentRepository {
  static final StudentRepository _instance =
      StudentRepository._internal();

  factory StudentRepository() {
    return _instance;
  }

  StudentRepository._internal();

  late Box<Student> _box;

  Future<void> init() async {
    _box = Hive.box<Student>("student_db");
  }

  List<Student> getAllStudents() {
    return _box.values.toList();
  }

  Future<void> addStudent(Student student) async {
    await _box.add(student);
  }

  Future<void> deleteStudent(Student student) async {
    await student.delete();
  }

  Future<void> updateStudent(Student student) async {
    await student.save();
  }
}