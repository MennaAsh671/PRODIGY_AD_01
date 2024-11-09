import 'package:flutter/material.dart';

import '../entities/buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ? "0"
                          : "$number1$operand$number2",
                      style: const TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              Wrap(
                children: Buttons.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: value == Buttons.no0 ? 395 / 2 : (395 / 4),
                        height: 500 / 5,
                        child: buildButton(value),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Buttons.delete) {
      del();
      return;
    }

    if (value == Buttons.clear) {
      clearAll();
      return;
    }

    if (value == Buttons.percent) {
      convertToPercentage();
      return;
    }

    if (value == Buttons.calculate) {
      calc();
      return;
    }

    appendValue(value);
  }

  // calculates the result
  void calc() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Buttons.add:
        result = num1 + num2;
        break;
      case Buttons.subtract:
        result = num1 - num2;
        break;
      case Buttons.multiply:
        result = num1 * num2;
        break;
      case Buttons.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  // converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calc();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  // clears all output
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // ##############
  // delete one from the end
  void del() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  // #############
  // appends value to the end
  void appendValue(String value) {
    // if is operand and not "."
    if (value != Buttons.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calc();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && number1.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (number1.isEmpty || number1 == Buttons.no0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Buttons.dot && number2.contains(Buttons.dot)) return;
      if (value == Buttons.dot && (number2.isEmpty || number2 == Buttons.no0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  // ########
  Color getBtnColor(value) {
    return [Buttons.delete, Buttons.clear].contains(value)
        ? Colors.blueGrey
        : [
            Buttons.percent,
            Buttons.multiply,
            Buttons.add,
            Buttons.subtract,
            Buttons.divide,
            Buttons.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
