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

  bool isSearching = false;

  void refreshStudents() {
    searchStudent(searchController.text);
  }

  Future<void> loadStudents() async {
    await Future.delayed(const Duration(seconds: 2));
  }

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

        leading: IconButton(
          onPressed: () {
            // Menu action
          },
          icon: const Icon(Icons.menu, color: Colors.white),
        ),

        centerTitle: true,

        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: searchStudent,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search Student",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                "Student List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  refreshStudents();
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Student already exists")),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                final student = filteredStudents[index];

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Card(
                                    elevation: 6,
                                    shadowColor: Colors.blue.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                size: 35,
                                                color: Colors.blue,
                                              ),
                                            ),

                                            const SizedBox(width: 15),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    student.name,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 8),

                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.cake,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        "Age: ${student.age}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 5),

                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.school,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                          student.course,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditStudentScreen(
                                                                student:
                                                                    student,
                                                              ),
                                                        ),
                                                      );
                                                      refreshStudents();
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(height: 8),

                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              "Delete Student",
                                                            ),
                                                            content: const Text(
                                                              "Are you sure you want to delete this student?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Cancel",
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () async {
                                                                  await repository
                                                                      .deleteStudent(
                                                                        student,
                                                                      );

                                                                  refreshStudents();

                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Delete",
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
                 ValueListenableBuilder(
  valueListenable: studentBox.listenable(),
  builder: (context, Box<Student> box, _) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 97, 159, 209),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.groups,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            "Total Students: ${box.length}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
