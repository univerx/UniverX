import 'package:flutter/material.dart';
import 'package:univerx/database/database_helper.dart';
import 'package:univerx/features/calendar/data/datasources/fetchAndUpdateEvents.dart';

class CustomImportButton extends StatelessWidget {
  // add _loadevents required
  final void Function() loadEvents;


  const CustomImportButton({
    Key? key,
    required this.loadEvents,
  }) : super(key: key);

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
                loadEvents();
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
    return ElevatedButton(
      onPressed: () => showIcsLinkInputDialog(context),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Color.fromARGB(255, 20, 21, 27),
      ),
      child: const Text(
        'Import',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
