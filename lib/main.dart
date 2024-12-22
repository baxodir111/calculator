import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';

  // Yordamchi usul: oxirgi belgi operator ekanligini tekshirish
  bool _isLastCharOperator(String value) {
    if (value.isEmpty) return false;
    return ['+', '-', '×', '÷'].contains(value[value.length - 1]);
  }


  String _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      return eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
    } catch (e) {
      throw Exception('Noto‘g‘ri ifoda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Ko'rsatish maydoni
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                color: Colors.black,
                child: Text(
                  input.isEmpty ? '0' : input,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Tugmalar maydoni
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildRow(['+', '-', '×', '÷']),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildRow(['7', '8', '9']),
                                _buildRow(['4', '5', '6']),
                                _buildRow(['1', '2', '3']),
                                _buildRow(['0', '.', 'AC']),
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => ('='),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, bottom: 4, right: 8),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  '=',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tugmalar qatorini yaratish uchun yordamchi
  Widget _buildRow(List<String> values) {
    return Expanded(
      flex: 1,
      child: Row(
        children: values.map((value) {
          return Expanded(
            child: AspectRatio(
              aspectRatio: 1, // Kvadrat tugmalar
              child: Container(
                margin: EdgeInsets.all(4), // Tugmalar orasidagi bo'shliq
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                child: value.isEmpty
                    ? SizedBox.shrink()
                    : ElevatedButton(
                  onPressed: () => (value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    value == 'AC' ? Colors.red : Colors.white,
                    foregroundColor:
                    value == 'AC' ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero, // Kvadrat shaklni ta'minlash
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
