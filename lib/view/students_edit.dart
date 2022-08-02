import 'package:first_api_app/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';

class StudentsEdit extends StatefulWidget {
  const StudentsEdit({Key? key, required this.studentedit}) : super(key: key);
  final Student studentedit;

  @override
  State<StudentsEdit> createState() => _StudentsEditState();
}

class _StudentsEditState extends State<StudentsEdit> {
  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.studentedit.firstName!;
    lastNameController.text = widget.studentedit.lastName!;
    imageUrlController.text = widget.studentedit.avatar!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editing"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(hintText: "Image"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Image.network(
              imageUrlController.text,
              height: 70,
              width: 70,
              errorBuilder: (context, object, st) => const Icon(Icons.info),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: isLoading ? null : () => updateData(context),
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }

  updateData(context) async {
    setState(() => isLoading = true);
    http.Response response = await http.put(
        Uri.parse("${AppConfig.baseUrl}/students/${widget.studentedit.id}"),
        body: {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "avatar": imageUrlController.text,
        });

    if (response.statusCode == 200) {
      setState(() => isLoading = false);
      Navigator.pop(context, true);
    }
  }
}
