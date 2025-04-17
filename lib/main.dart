// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:tax_calculator/AddPerMonth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax Calculator',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, TextEditingController> controllers = {
    'pension': TextEditingController(),
    'month': TextEditingController(),
    'tdr': TextEditingController(),
    'acrude': TextEditingController(),
    'provision': TextEditingController(),
    'standardDeduction': TextEditingController(),
    'taxAdd': TextEditingController(),
    'taxInterest': TextEditingController(),
    'limit': TextEditingController(),
    'chess': TextEditingController(),
    'tds': TextEditingController(),
  };
  List<TextEditingController> otherIncomes = [];
  double totalPension = 0, totalTdr = 0, income = 0, nti = 0, dp = 0, chess = 0;

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    otherIncomes.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      controllers.forEach((_, controller) => controller.clear());
      otherIncomes.clear();
      totalPension = totalTdr = income = nti = dp = chess = 0;
    });
  }

  void _calculateIncome() {
    setState(() {
      double pension = double.tryParse(controllers['pension']!.text) ?? totalPension;
      double month = double.tryParse(controllers['month']!.text) ?? 1;
      double tdr = double.tryParse(controllers['tdr']!.text) ?? totalTdr;
      double acrude = double.tryParse(controllers['acrude']!.text) ?? 0;
      double provision = double.tryParse(controllers['provision']!.text) ?? 0;
      double standardDeduction = double.tryParse(controllers['standardDeduction']!.text) ?? 0;

      double otherIncome = otherIncomes.fold(0.0, (sum, controller) => sum + (double.tryParse(controller.text) ?? 0));
      income = (pension * month) + tdr + acrude + otherIncome - provision - standardDeduction;
    });
  }

  void _calculateTax() {
    setState(() {
      double taxAdd = double.tryParse(controllers['taxAdd']!.text) ?? 0;
      double taxInterest = double.tryParse(controllers['taxInterest']!.text) ?? 0;
      double limit = double.tryParse(controllers['limit']!.text) ?? 0;
      double tds = double.tryParse(controllers['tds']!.text) ?? 0;
      double chessRate = double.tryParse(controllers['chess']!.text) ?? 0;

      nti = (((income % (limit * 100000)) * (taxInterest / 100)) + taxAdd);
      chess = nti + (nti * chessRate / 100);
      dp = chess - tds;
    });
  }

  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controllers[key],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tax Calculator'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField('Pension', 'pension')),
                Expanded(child: _buildTextField('Month', 'month')),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPerMonth()));
                    if (result != null) {
                      setState(() {
                        totalPension = result['totalPension'];
                        totalTdr = result['totalTdr'];
                      });
                    }
                  },
                  child: Text('Add Per Month'),
                ),
              ],
            ),
            _buildTextField('TDR Interest', 'tdr'),
            _buildTextField('Acrude Interest', 'acrude'),
            _buildTextField('Less Provision', 'provision'),
            _buildTextField('Standard Deduction', 'standardDeduction'),
            ElevatedButton(onPressed: _calculateIncome, child: Text('Calculate Income')),
            if (income != 0) Text('Total Income: $income'),
            _buildTextField('Tax Addition', 'taxAdd'),
            _buildTextField('Tax Interest', 'taxInterest'),
            _buildTextField('Limit (e.g., 3, 5)', 'limit'),
            _buildTextField('TDS', 'tds'),
            _buildTextField('Chess (e.g., 3, 5)', 'chess'),
            ElevatedButton(onPressed: _calculateTax, child: Text('Calculate Tax')),
            if (nti != 0) Text('Net Taxable Income: $nti\nWith Chess: $chess\nDeduction Payable: $dp'),
            ElevatedButton(onPressed: _clearAll, child: Text('Clear')),
          ],
        ),
      ),
    );
  }
}
