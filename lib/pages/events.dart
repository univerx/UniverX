import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:univerx/pages/home.dart';
import 'package:univerx/database_helper.dart'; // Assuming you use the same database helper for assignments
import 'package:univerx/models/eventModel.dart'; // Assuming you have a model for assignments
import 'package:univerx/event_service.dart'; // Assuming you have a model for assignments
import 'package:univerx/events/fetchAndUpdateEvents.dart'; // Assuming you have a model for assignments

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

  void _showIcsLinkInputDialog(BuildContext context) async{
    final TextEditingController icsLinkController = TextEditingController();

    final result = await DatabaseHelper.instance.getCalendarICS();
    if (result != null) {
      icsLinkController.text = result.toString();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter .ics Link'),
          content: TextField(
            controller: icsLinkController,
            decoration: InputDecoration(
              hintText: 'https://sample.com/a.ics',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // ezt itt szebben kene EEEEEEEEEEEEEEEEEEEEEDTSADKSHFDAHSFLSAJFLKASJFLKSAJFKLS
                String icsLink = icsLinkController.text;
                if (icsLink == '') {
                  DatabaseHelper.instance.updateCalendarICS(icsLink);
                  DatabaseHelper.instance.clearAllEvents();
                }
                else if (result == null) {
                  DatabaseHelper.instance.saveCalendarICS(icsLink);
                  await fetchAndUpdateEventsFromIcs(icsLink);
                } else{
                  DatabaseHelper.instance.updateCalendarICS(icsLink);
                  await fetchAndUpdateEventsFromIcs(icsLink);
                }
                Navigator.of(context).pop(); // Close the dialog
                _loadEvents();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
                _showIcsLinkInputDialog(context);
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.blue, // Change the color as needed
                child: Icon(
                  Icons.add_link, color: Colors.white, size: 20.0,
                )
              ),
            ),
            IconButton(
              onPressed: () {
                // to second page
                //Navigator.pushNamed(context, '/second');
              },
              icon: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 20, 21, 27), // Change the color as needed
                child: Text(
                  "D", // Replace with your letter
                  style: TextStyle(color: Colors.white,fontFamily: "sfpro"),
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
