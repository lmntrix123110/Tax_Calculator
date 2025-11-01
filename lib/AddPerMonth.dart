// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class AddPerMonth extends StatefulWidget {
  @override
  _AddPerMonthState createState() => _AddPerMonthState();
}

class _AddPerMonthState extends State<AddPerMonth> {
  int startMonth = 1;
  int pensionFields = 1;
  int tdrFields = 1;
  List<List<TextEditingController>> pensionControllers = [];
  List<List<TextEditingController>> tdrControllers = [];
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    pensionControllers = List.generate(
      12,
      (_) => List.generate(pensionFields, (_) => TextEditingController()),
    );
    tdrControllers = List.generate(
      12,
      (_) => List.generate(tdrFields, (_) => TextEditingController()),
    );
  }

  void _calculateTotal() {
    double totalPension = pensionControllers.fold(0.0, (sum, controllers) {
      return sum +
          controllers.fold(
            0.0,
            (innerSum, controller) =>
                innerSum + (double.tryParse(controller.text) ?? 0),
          );
    });

    double totalTdr = tdrControllers.fold(0.0, (sum, controllers) {
      return sum +
          controllers.fold(
            0.0,
            (innerSum, controller) =>
                innerSum + (double.tryParse(controller.text) ?? 0),
          );
    });

    Navigator.pop(context, {
      'totalPension': totalPension,
      'totalTdr': totalTdr,
    });
  }

  void _addPensionField() {
    setState(() {
      pensionFields++;
      for (var i = 0; i < 12; i++) {
        pensionControllers[i].add(TextEditingController());
      }
    });
  }

  void _addTdrField() {
    setState(() {
      tdrFields++;
      for (var i = 0; i < 12; i++) {
        tdrControllers[i].add(TextEditingController());
      }
    });
  }

  void _resetAll() {
    setState(() {
      startMonth = 1;
      pensionFields = 1;
      tdrFields = 1;
      for (var controllers in pensionControllers) {
        for (var controller in controllers) {
          controller.dispose();
        }
      }
      for (var controllers in tdrControllers) {
        for (var controller in controllers) {
          controller.dispose();
        }
      }
      _initializeControllers();
    });
  }

  @override
  void dispose() {
    for (var controllers in pensionControllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    for (var controllers in tdrControllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text('Add Per Month', style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              style: TextStyle(color: Colors.blue),
              value: startMonth,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white54,
                labelText: 'Select Starting Month',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: Colors.white70),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: Colors.white70),
                ),
              ),
              items:
                  List.generate(12, (index) => index + 1).map((month) {
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text(months[month - 1]),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  startMonth = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  int monthIndex = (startMonth - 1 + index) % 12;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        months[monthIndex],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      ...List.generate(pensionFields, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: TextField(
                            style: TextStyle(color: Colors.blue),
                            obscureText: false,
                            controller: pensionControllers[index][i],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white54,
                              labelText: 'Pension',
                              labelStyle: TextStyle(color: Colors.blue),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      ...List.generate(tdrFields, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: TextField(
                            controller: tdrControllers[index][i],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white54,
                              labelText: 'TDR',
                              labelStyle: TextStyle(color: Colors.blue),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addPensionField,
                  child: Text(
                    '+ Add Pension',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTdrField,
                  child: Text(
                    '+ Add TDR',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculateTotal,
                  child: Text('Save', style: TextStyle(color: Colors.blue)),
                ),
                ElevatedButton(
                  onPressed: _resetAll,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
