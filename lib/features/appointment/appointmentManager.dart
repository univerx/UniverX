// dialog_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univerx/models/assignment.dart';
import 'package:univerx/models/exam.dart';
import 'package:univerx/database/database_helper.dart';


Future<void> addAssignmentOrExam(BuildContext context, ) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 51, 70),
        title: Center(
          child: Text(
            'Create Event',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(125, 199, 218, 246),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showAssignmentDialog(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Assignment',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(129, 199, 218, 246),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showExamDialog(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Exam',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showAssignmentDialog(BuildContext context) async {
  final assignment = await showDialog<Assignment>(
    context: context,
    builder: (BuildContext context) {
      String assignmentName = '';
      String description = '';
      DateTime? assignmentDate;
      TextEditingController dateTimeController = TextEditingController();
      final _formKey = GlobalKey<FormState>();

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 51, 70),
        title: const Center(
          child: Text(
            'Add Assignment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    assignmentName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: dateTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Due Date and Time',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        assignmentDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(assignmentDate!);
                      }
                    }
                  },
                  validator: (value) {
                    if (assignmentDate == null) {
                      return 'Date and Time cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromARGB(129, 199, 218, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(
                            context,
                            Assignment(
                              classId: -1, // TODO: Implement classId
                              title: assignmentName,
                              description: description,
                              dueDate: assignmentDate!,
                              isUserCreated: true,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromARGB(129, 199, 218, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      ),
                      child: Text('Create Task', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  if (assignment != null) {
    await DatabaseHelper.instance.insertAssignment(assignment);
    // Call a callback or refresh the data as needed
  }
}

Future<void> _showExamDialog(BuildContext context) async {
  final exam = await showDialog<Exam>(
    context: context,
    builder: (BuildContext context) {
      String examName = '';
      String description = '';
      String location = '';
      DateTime? startTime;
      DateTime? endTime;
      TextEditingController startDateTimeController = TextEditingController();
      TextEditingController endDateTimeController = TextEditingController();
      final _formKey = GlobalKey<FormState>();

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 51, 70),
        title: Center(
          child: Text(
            'Add Exam',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color.fromARGB(255, 253, 253, 253),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    examName = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    location = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: startDateTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start Date and Time',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        startTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        startDateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(startTime!);
                        endDateTimeController.text = ''; // Reset end date time controller
                        endTime = null; // Reset end time
                      }
                    }
                  },
                  validator: (value) {
                    if (startTime == null) {
                      return 'Start Date and Time cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: endDateTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End Date and Time',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () async {
                    if (startTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please set the start date and time first.')),
                      );
                      return;
                    }
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: startTime!,
                      firstDate: startTime!,
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startTime!),
                      );
                      if (selectedTime != null) {
                        final selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        if (selectedDateTime.isAfter(startTime!)) {
                          endTime = selectedDateTime;
                          endDateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm').format(endTime!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('End time must be after start time.')),
                          );
                        }
                      }
                    }
                  },
                  validator: (value) {
                    if (endTime == null) {
                      return 'End Date and Time cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromARGB(129, 199, 218, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(
                            context,
                            Exam(
                              classId: -1, // TODO: Implement classId
                              title: examName,
                              description: description,
                              startTime: startTime!,
                              endTime: endTime!,
                              location: location,
                              isUserCreated: true,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(129, 199, 218, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      ),
                      child: Text('Create Task', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  if (exam != null) {
    await DatabaseHelper.instance.insertExam(exam);
    // Call a callback or refresh the data as needed
  }
}
