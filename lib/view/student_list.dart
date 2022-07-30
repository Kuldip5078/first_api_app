import 'dart:convert';
import 'package:first_api_app/utils/app_config.dart';
import 'package:first_api_app/view/student_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final _formKey = GlobalKey<FormState>();
  List<Student> students = [];
  bool isLoading = false;

  // final _controller = TextEditingController();
  // String firstName = "";
  // String lastName = "";
  // String Mobileno = "";
  // String firstNamearror = "";
  // String lastNamearror = "";
  // String Mobilenoaroor = "";

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 16,
                      child: SizedBox(
                        height: 350.0,
                        width: 360.0,
                        child: ListView(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            Center(
                              child: TextFormField(
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "Enter firstname:";
                                    }
                                  }),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter FirstName')),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return "Enter lastname:";
                                }
                              }),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter LastName'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return "Enter moble number:";
                                }
                              }),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Mobile Number'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {}
                              },
                              child: Text(
                                'Submit',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : students.isEmpty
              ? const Center(child: Text("No students"))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentDetails(student: students[index]),
                        ),
                      );
                    },
                    title: Text(
                        "${students[index].firstName} ${students[index].lastName}"),
                  ),
                ),
    );
  }

  void getStudents() async {
    setState(() => isLoading = true);
    http.Response response =
        await http.get(Uri.parse("${AppConfig.baseUrl}/students"));
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
