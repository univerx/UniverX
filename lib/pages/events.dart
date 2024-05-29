import 'package:flutter/material.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/database_helper.dart'; // Assuming you use the same database helper for assignments
import 'package:univerx/models/eventModel.dart'; // Assuming you have a model for assignments
import 'package:univerx/event_service.dart'; // Assuming you have a model for assignments
class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Events> {
  List<EventModel?> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final events = await DatabaseHelper.instance.getAllEvents();
    setState(() {
      _allEvents = events;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Event Manager",
            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // to second page
                //Navigator.pushNamed(context, '/second');
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.blue, // Change the color as needed
                child: Text(
                  "D", // Replace with your letter
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _allEvents.length,
          itemBuilder: (context, index) {
            final events = _allEvents[index];
            return ListTile(
              title: Text(events?.summary ?? '', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Location: ${events?.location ?? ''}\n Start: ${events?.start ?? ''}\nEnd: ${events?.end ?? ''}',
                style: TextStyle(color: Colors.white70),
              ),
            );
          },
        ),
      ),
    );
  }
}
