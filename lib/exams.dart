import 'package:flutter/material.dart';
import './main2.dart';

void exams() {
  runApp(const Exam());
}

class Exam extends StatelessWidget {
  const Exam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyFlutterList(),
      title: 'My Flutter List',
    );
  }
}

class MyFlutterList extends StatefulWidget {
  const MyFlutterList({super.key});

  @override
  _MyFlutterListState createState() => _MyFlutterListState();
}

class _MyFlutterListState extends State<MyFlutterList> {
  List<Termin> terminiList = [];

  @override
  Widget build(BuildContext context) {
    void addTerminData(Termin termin) {
      setState(() {
        terminiList.add(termin);
        //_eventsList.add('General Meeting');
      });
    }

    void showUserDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: AddDialog(addTerminData),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termini za ispiti i kolokviumi'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: showUserDialog,
        ),
      ),
      body: SizedBox(
        height: 400,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
              margin: const EdgeInsets.all(4),
              elevation: 8,
              child: ListTile(
                title: Text(
                  terminiList[index].ime,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  terminiList[index].datum,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
          itemCount: terminiList.length,
        ),
      ),
    );
  }
}

class Termin {
  final String ime;
  final String datum;

  Termin(this.ime, this.datum);
}

class AddDialog extends StatefulWidget {
  final Function(Termin) addTermin;

  const AddDialog(this.addTermin, {super.key});

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  @override
  Widget build(BuildContext context) {
    Widget buildTextField(String hint, TextEditingController controller) {
      return Container(
        margin: const EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration(
            labelText: hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ),
            ),
          ),
          controller: controller,
        ),
      );
    }

    var nameController = TextEditingController();
    var timeController = TextEditingController();
    const terminNaslov = 'Dodaj nov termin: ';
    const predmetNaslov = 'Naslov na predmet: ';
    const datumNaslov = 'Datum: ';
    const dodavanjeNaslov = 'Dodadi termin';

    return Container(
      padding: const EdgeInsets.all(8),
      height: 350,
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              terminNaslov,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.blueGrey,
              ),
            ),
            buildTextField(predmetNaslov, nameController),
            buildTextField(datumNaslov, timeController),
            ElevatedButton(
              onPressed: () {
                final termin = Termin(nameController.text, timeController.text);
                widget.addTermin(termin);
                Navigator.of(context).pop();
              },
              child: const Text(dodavanjeNaslov),
            ),
          ],
        ),
      ),
    );
  }
}
