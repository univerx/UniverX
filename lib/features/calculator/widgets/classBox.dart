import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univerx/models/class.dart';
import 'package:univerx/features/common/widgets/box_3d.dart';

class ClassItem extends StatelessWidget {
  final String title;
  final TextEditingController creditsController;
  final TextEditingController gradeController;

  ClassItem({
    required this.title,
    required this.creditsController,
    required this.gradeController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 60,
      decoration: Box3D(),
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Lower the radius
          color: Color.fromARGB(255, 38, 51, 70),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                // Credit Input Field
                SizedBox(
                  width: 66,
                  child: Container(
                    width: double.infinity,
                    height: 47,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 28, 35, 45),
                    ),
                    child: NumberInput(
                      controller: creditsController,
                      label: '',
                      allowDecimal: false,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Grade Input Field
                SizedBox(
                  width: 66,
                  child: Container(
                    width: double.infinity,
                    height: 47,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 28, 35, 45),
                    ),
                    child: NumberInput(
                      controller: gradeController,
                      label: '',
                      allowDecimal: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool allowDecimal;

  NumberInput({
    required this.controller,
    required this.label,
    this.allowDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
      ],
      textAlign: TextAlign.center, // Centers the text
      style: TextStyle(
        color: Colors.white, // Text color
        fontSize: 18, // Font size of the input number
        fontWeight: FontWeight.bold, // Font weight of the input number
        // fontFamily: 'YourFontFamily', // You can also specify a custom font family
      ),
      decoration: InputDecoration(
        border: InputBorder.none, // Removes underline
        isDense: true, // Reduces height of the input
        contentPadding: EdgeInsets.symmetric(vertical: 10), // Padding inside the input box
      ),
    );
  }

  String _getRegexString() => allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
