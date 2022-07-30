import 'dart:convert';

import 'package:first_api_app/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({Key? key, required this.student}) : super(key: key);
  final Student student;
  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  Student? student;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isLoading
              ? const Text("Student details")
              : Text("${student?.firstName} ${student?.lastName}")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Center(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage("${student?.avatar}"),
                            fit: BoxFit.cover)),
                  ),
                  Text("First name: ${student?.firstName}"),
                  Text("Last name: ${student?.lastName}"),
                ],
              ),
            ),
    );
  }

  void getUserDetails() async {
    setState(() => isLoading = true);
    http.Response response = await http
        .get(Uri.parse("${AppConfig.baseUrl}/students/${widget.student.id}"));

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      student = Student.fromMap(decoded);
      setState(() => isLoading = false);
    }
  }
}
