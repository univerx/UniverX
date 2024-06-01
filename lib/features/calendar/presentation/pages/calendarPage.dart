import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/features/calendar/data/model/calendarModel.dart';
import 'package:univerx/event_service.dart'; // Assuming you have a model for assignments
import 'package:univerx/features/calendar/data/datasources/fetchAndUpdateEvents.dart'; // Assuming you have a model for assignments

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/calendar/presentation/widgets/icsLinkManager.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

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

  void showIcsLinkInputDialog(BuildContext context) async{
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: DefaultAppBar(
        title: "UniX-Calendar",
        showBackButton: true,
        icsButton: CustomImportButton(
          onPressed: () => showIcsLinkInputDialog(context),
        ),
      ),

      endDrawer: const DrawerMenu(), //Profile_menu pop up

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
    );
    
  }
}
