import 'package:first_api_app/utils/app_config.dart';
import 'package:first_api_app/view/students_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController avatarcontroller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    
    firstnamecontroller.addListener(() {
      // print(firstnamecontroller.text);
    });
    lastnamecontroller.addListener(() {
      // print(lastnamecontroller.text);
    });
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert());
    return const StudentList();
  }

  @override
  void dispose() {
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    //emailcontroller.dispose();
    avatarcontroller.dispose();

    super.dispose();
  }

  showAlert() async {
    var isAdded = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),

            //title: const Center(child: Text("Register Detail")),
            content: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: ListBody(
                  children: [
                    TextFormField(
                      controller: firstnamecontroller,
                      decoration: const InputDecoration(
                        labelText: " First Name.....",
                      ),
                      validator: ((value) {
                        // print(value);
                        if (value!.isEmpty) {
                          return 'feild cannot be empty';
                        }
                      }),
                    ),
                    TextFormField(
                      controller: lastnamecontroller,
                      decoration: const InputDecoration(
                        labelText: " Last name....",
                      ),
                      validator: ((value) {
                        // print(value);
                        if (value!.isEmpty) {
                          return 'feild cannot be empty';
                        }
                      }),
                    ),
                    // TextFormField(
                    //     controller: emailcontroller,
                    //     decoration: const InputDecoration(
                    //       labelText: " Email id......",
                    //     ),
                    //     validator: ((value) {
                    //       if (value!.isEmpty) {
                    //         return 'feild cannot be empty';
                    //       }
                    //     })),
                    TextFormField(
                        controller: avatarcontroller,
                        decoration: const InputDecoration(
                          labelText: " Enter image link",
                        ),
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'feild cannot be empty';
                          }
                        }))
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      addStudentApi(context);
                    }
                  },
                  child: const Center(child: Text("Submit")))
            ],
          );
        });

    if (isAdded != null && isAdded) {
      getstudents();
    }
  }

  void getstudents() {}

  void addStudentApi(context) async {
    http.Response response =
        await http.post(Uri.parse('${AppConfig.baseUrl}/students'), body: {
      "firstName": firstnamecontroller.text,
      "lastName": lastnamecontroller.text,
      "avatar": avatarcontroller.text,
      // "email ": emailcontroller.text
    });
    if (response.statusCode == 201) {
      firstnamecontroller.clear();
      lastnamecontroller.clear();
      //  emailcontroller.clear();
      avatarcontroller.clear();
      Navigator.pop(context, true);
    }
  }
}
