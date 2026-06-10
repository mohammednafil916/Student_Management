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

  Future<bool> addStudent(Student student) async {
    bool alreadyExists = _box.values.any(
      (s) =>
          s.name.toLowerCase() == student.name.toLowerCase() &&
          s.age == student.age &&
          s.course.toLowerCase() == student.course.toLowerCase(),
    );

    if (alreadyExists) {
      return false;
    }

    await _box.add(student);
    return true;
  }

  Future<bool> updateStudent(Student student) async {
    final students = _box.values.toList();

    bool alreadyExists = students.any(
      (s) =>
          s.key != student.key &&
          s.name.toLowerCase() == student.name.toLowerCase() &&
          s.age == student.age &&
          s.course.toLowerCase() == student.course.toLowerCase(),
    );

    if (alreadyExists) {
      return false;
    }

    await student.save();
    return true;
  }

  Future<void> deleteStudent(Student student) async {
    await student.delete();
  }
}