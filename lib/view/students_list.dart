import 'dart:convert';
import 'package:first_api_app/utils/app_config.dart';
import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'package:http/http.dart' as http;

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
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
      appBar: AppBar(
        title: const Center(child: Text("Students")),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                    "${students[index].id}        ${students[index].firstName} ${students[index].lastName} "),
              ),
            ),
    );
  }

  void getStudents() async {
    setState(() => isLoading = true);
    http.Response response =
        await http.get(Uri.parse("${AppConfig.baseUrl}students"));
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      if (decoded is List) {
        for (var stud in decoded) {
          students.add(Student.fromMap(stud as Map<String, dynamic>));
        }
      }
      setState(() => isLoading = false);
    }
  }
}
