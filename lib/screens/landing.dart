import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_mis/screens/calendar_screen.dart';
import 'package:lab_mis/screens/login.dart';
import 'package:lab_mis/services/notification.dart';

import '../model/appointment.dart';
import '../widgets/newEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final List<Termin> _appointments = [
    Termin(id: "1", title: "MIS", date: DateTime.parse("2022-12-12 12:00:00")),
    Termin(
      id: "2",
      title: "Calculus",
      date: DateTime.parse("2022-12-12 20:00:00"),
    ),
    Termin(
      id: "3",
      title: "Web Design",
      date: DateTime.parse("2023-05-05 05:00:00"),
    ),
  ];

  void openModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: createNewElement(_addTermin),
          );
        });
  }

  void _deleteTermin(String id) {
    setState(() {
      _appointments.removeWhere((termin) => termin.id == id);
    });
  }

    void _addTermin(Termin termin) {
    setState(() {
      _appointments.add(termin);
    });
  }

  String _editDate(DateTime date) {
    String dateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> splittedString = dateString.split(" ");
    String modifiedTime = splittedString[1].substring(0, 5);

    return '${splittedString[0]} | ${modifiedTime}h';
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser?.email;
    return AppBar(
      title: const Text("Exams"),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined),
          onPressed: () => openModal(context),
        ),
        ElevatedButton(
          onPressed: _logOut,
          child: const Text("Log out"),
        )
      ],
    );
  }

  Widget _createBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
    children: <Widget>[
      Center(
        child: _appointments.isEmpty
            ? const Text("No exams scheduled")
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _appointments.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        vertical: 7, horizontal: 10),
                    child: ListTile(
                      tileColor: Colors.purple,
                      title: Text(
                        _appointments[index].title,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        _editDate(_appointments[index].date),
                        style: const TextStyle(color: Colors.white,),
                      ),
                      trailing: IconButton(
                        color: Colors.white,
                          onPressed: () =>
                              _deleteTermin(_appointments[index].id),
                          icon: const Icon(Icons.delete_outline)),
                    ),
                  );
                },
              ),
      ),
      ElevatedButton.icon(
        icon: const Icon(
          Icons.calendar_month_outlined,
          size: 30,
        ),
        label: const Text(
          "Calendar",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CalendarScreen(_appointments)));
        },
      ),
      ElevatedButton.icon(
        icon: const Icon(
          Icons.notifications,
          size: 30,
        ),
        label: const Text(
          "Local Notification",
          style: TextStyle(fontSize: 20),
          selectionColor: Colors.white,
        ),
        onPressed: () async {
          await service.showNotification(
              id: 0,
              title: 'You have upcoming exams',
              body: 'Check your calendar');
        },
      )
    ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(context),
    );
  }
}
