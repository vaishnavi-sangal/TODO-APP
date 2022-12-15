import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isedit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;

    if (todo != null) {
      isedit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isedit ? 'Edit Todo' : 'Add Todo')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isedit ? updateData : submitData,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(isedit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cannot update');
      return;
    }
    final id = todo['_id'];
    //final
    final title = titleController.text;
    final desciption = descriptionController.text;
    final body = {
      "title": title,
      "description": desciption,
      "is_completed": false,
    };
    final url = 'http://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      showSuccess('Updation successful');
    } else {
      showError('Updation failed');
      //print('Creation failed');
      //print(response.body);
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final desciption = descriptionController.text;
    final body = {
      "title": title,
      "description": desciption,
      "is_completed": false,
    };

    final url = 'http://api.nstack.in/v1/todos';

    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      // print(response.statusCode);
      showSuccess('Creation Success');
    } else {
      showError('Creation failed');
      //print('Creation failed');
      //print(response.body);
    }

    //http.post(url)
  }

  void showSuccess(String message) {
    final snack = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void showError(String message) {
    final snack = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
