import 'dart:convert';
import 'package:first_api_app/view/student_detail.dart';
import 'package:first_api_app/view/students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../utils/app_config.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];
  bool isLoading = false;

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const Students())));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Center(child: Text("Students")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  getStudents();
                },
                child: const Icon(Icons.rotate_left)),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : students.isEmpty
              ? const Center(child: Text("No Students"))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  StudentDetail(student: students[index]))));
                    },
                    title: Text(
                        "${students[index].firstName} ${students[index].lastName}"),
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage("${students[index].avatar}")),
                  ),
                ),
    );
  }

  void getStudents() async {
    setState(() => isLoading = true);
    http.Response response =
        await http.get(Uri.parse("${AppConfig.baseUrl}/students"));
    // print(response.body);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      // print(decoded.runtimeType);

      if (decoded is List) {
        for (var stud in decoded) {
          students.add(Student.fromMap(stud as Map<String, dynamic>));
        }
      }
      setState(() => isLoading = false);
    }
  }
}
