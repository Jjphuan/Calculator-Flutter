import 'package:calculator/button_value.dart';
import 'package:flutter/material.dart';

class Calculatorscreen extends StatefulWidget {
  const Calculatorscreen({super.key});

  @override
  State<Calculatorscreen> createState() => _CalculatorscreenState();
}

String number1 = "";
String operand = "";
String number2 = "";

class _CalculatorscreenState extends State<Calculatorscreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children:
                  Btn.buttonValues
                      .map(
                        (value) => SizedBox(
                          width:
                              Btn.calculate.contains(value)
                                  ? screenSize.width / 2
                                  : screenSize.width / 4,
                          height: screenSize.width / 4.5,
                          child: buildButton(value),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    void calculate() {
      if (number1.isEmpty || operand.isEmpty || number2.isEmpty) {
        return;
      }

      var result = 0.0;
      var num1 = double.parse(number1);
      var num2 = double.parse(number2);
      setState(() {
        switch (operand) {
          case Btn.add:
            result = num1 + num2;
            break;
          case Btn.subtract:
            result = num1 - num2;
            break;
          case Btn.multiply:
            result = num1 * num2;
            break;
          case Btn.divide:
            result = num1 / num2;
            break;
          default:
        }

        number1 = "$result";
        operand = "";
        number2 = "";

        if (number1.endsWith(".0")) {
          number1 = number1.substring(0, number1.length - 2);
        }
      });
    }

    void appendValue(String value) {
      if (value != Btn.dot && int.tryParse(value) == null) {
        if (operand.isNotEmpty && number2.isNotEmpty) {
          calculate();
        }
        operand = value;
      } else if (number1.isEmpty || operand.isEmpty) {
        if (value == Btn.dot && number1.contains(Btn.dot)) return;
        if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
          value = "0.";
        }
        number1 += value;
      } else if (number2.isEmpty || operand.isNotEmpty) {
        if (value == Btn.dot && number2.contains(Btn.dot)) return;
        if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
          value = "0.";
        }
        number2 += value;
      }

      setState(() {});
    }

    void delete() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }

      setState(() {});
    }

    void convertToPercentage() {
      if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      } else if (operand.isNotEmpty && number2.isEmpty) {
        return;
      }

      final number = double.parse(number1);

      setState(() {
        number1 = "${(number / 100)}";
        operand = "";
        number2 = "";
      });
    }

    void clearAll() {
      number1 = "";
      operand = "";
      number2 = "";

      setState(() {});
    }

    void clickBtn(String value) {
      if (value == Btn.del) {
        delete();
        return;
      } else if (value == Btn.clr) {
        clearAll();
        return;
      } else if (value == Btn.per) {
        convertToPercentage();
        return;
      } else if (value == Btn.calculate) {
        calculate();
        return;
      }

      appendValue(value);
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color:
            [Btn.del, Btn.clr].contains(value)
                ? Colors.lightBlue
                : [
                  Btn.add,
                  Btn.divide,
                  Btn.multiply,
                  Btn.subtract,
                  Btn.calculate,
                  Btn.per,
                ].contains(value)
                ? Colors.orange
                : const Color.fromARGB(255, 25, 21, 21),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          onTap: () => clickBtn(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
