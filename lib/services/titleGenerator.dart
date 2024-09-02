

String welcomeGenerator() {
  String res = "";
  DateTime now = DateTime.now();
  // if weekend
  if (now.weekday == 6 || now.weekday == 7) {
    res = "Kellemes hétvégét!";
  } else if (now.hour < 12) {
    res = "Jó reggelt!";
  } else if (now.hour < 18) {
    res = "Kellemes délutánt!";
  } else {
    res = "Jó estét!";
  }


  return res;
}