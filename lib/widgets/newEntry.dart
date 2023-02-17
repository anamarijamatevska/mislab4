import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_mis/model/appointment.dart';
import 'package:nanoid/nanoid.dart';

class createNewElement extends StatefulWidget {
  final Function addTermin;
  createNewElement(this.addTermin);

  @override
  State<StatefulWidget> createState() => _NewElementState();
}

class _NewElementState extends State<createNewElement> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();

  void _submitData() {
    if (titleController.text.isEmpty || dateController.text.isEmpty) {
      return;
    }

    int check1 = '-'.allMatches(dateController.text).length; //should be 2
    int check2 = ':'.allMatches(dateController.text).length; //should be 1

    if (dateController.text.length < 16 || check1 != 2 || check2 != 1) {
      print("Incorrect date format");
      return;
    }

    final String stringDate = '${dateController.text}:00';
    DateTime date = DateTime.parse(stringDate);

    final newTermin = Termin(
      id: nanoid(5),
      title: titleController.text,
      date: date,
    );
    widget.addTermin(newTermin);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: "Date (ex. 2022-01-01 15:00)"),
              controller: dateController,
              onSubmitted: (_) => _submitData(),
            ),
          ],
        ));
  }
}
