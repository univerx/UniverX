import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:univerx/structures/exam.dart';
import 'package:univerx/structures/exam_provider.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context, listen: false);



    // Create a list of Text widgets to display each exam's data
    List<Widget> examWidgets = examProvider.exams.map((exam) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${exam.name}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Date: ${exam.date.toString()}',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8), // Add some space between exams
        ],
      );
    }).toList();


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "UniX-PTE-TTK",
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // to second page
                //Navigator.pushNamed(context, '/second');
              },
              icon: 
                const CircleAvatar(
                  backgroundColor: Colors.blue, // Change the color as needed
                  child: Text(
                    "D", // Replace with your letter
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            )],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    
                    // ---------------------------------- upcoming classes/event
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color.fromARGB(255, 45, 45, 45),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Programozás II.",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "f/201",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 10), // Add some space between the row and the text below
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "→ Számítógép hálózatok",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "C/V/I",
                                  style: TextStyle(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align the text to the right
                            children: [
                              Text(
                                "Time left: 1 hour 20 min", // Display the time left text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[300], // Background color of the progress bar
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              borderRadius: BorderRadius.circular(20), // Color of the progress indicator
                              value: 0.8, // Value between 0.0 and 1.0 representing the progress
                            ),
                          ) // Add some space between the text and the progress bar
                          
                        ],
                      ),
                      // Content of the first container
                    ),

                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  // ---------------------------------- upcoming zh/ tests
                  Expanded(
                    child: 
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/zh'),
                          child: Container(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Text(
                                  "ZH",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Display the list of exams
                                ...examProvider.exams.map((exam) {
                                  return ListTile(
                                    textColor: Color.fromARGB(255, 255, 255, 255),
                                    title: Text(exam.name + ': ${examProvider.DateFormat(exam.date.toString())}'),
                                    //subtitle: Text('Date: ${examProvider.DateFormat(exam.date.toString())}'),
                                  );
                                }).toList(),
                              ],
                            ),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(255, 45, 45, 45),
                            ),
                          ),
                        ),
                      ),
                  ),


                  SizedBox(width: 10),
                  // ---------------------------------- upcoming assigments
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/assigments'),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text("Assigments", style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          // Content of the second container
                        ),
                      ),
                    )
                  ),
                  SizedBox(width: 10),           
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  // ---------------------------------- notess
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text("Notes", style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color.fromARGB(255, 45, 45, 45),
                      ),
                      // Content of the fourth container
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



