// ignore_for_file: prefer_contains

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gst_calculator/features/gst_calculator/data/models/gst_ui_model.dart';
import 'package:math_expressions/math_expressions.dart';

part 'gst_calculator_state.dart';

class GstCalculatorCubit extends Cubit<GstCalculatorState> {
  GstCalculatorCubit() : super(GstCalculatorLoadingState());
  String lastvalue = "abc";
  int dotCount = 0;
  String answerper = "";
  List opraters = ["+", "-", "x", "÷", ".", "%"];
  TextEditingController textEditingController = TextEditingController();
  int cursor = 0;

  void init() {
    dotCount = 0;
    lastvalue = "abc";
    answerper = "";
    textEditingController.clear();
    cursor = 0;
    emit(
      GstCalculatorLoadedState(
        addValue: "",
        totalValue: "",
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
        button: false,
        islastEqul: false,
        textEditingController: TextEditingController(),
        cursorPos: -1,
      ),
    );
  }

  void calculation({required String name, required GstCalculatorLoadedState state, required BuildContext context}) {
    if (name == "=") {
      equal(state: state, context: context, values: state.addValue, button: true);

      if (state.iGst.isNotEmpty) {
        emit(state.copywith(button: false, islastEqul: true));
      } else {
        emit(state.copywith(button: true, islastEqul: true));
      }
    } else if (name == "⌫") {
      String vales = remove(state: state, context: context);
      if (vales.endsWith("x") == true ||
          vales.endsWith("+") == true ||
          vales.endsWith("-") == true ||
          vales.endsWith("÷") == true ||
          vales.endsWith("%") == true ||
          vales.endsWith(".") == true) {
        vales = vales;
      } else {
        equal(state: state, context: context, values: vales, button: false);
      }
    } else if (name == "AC") {
      init();
    } else if (name.endsWith("%") && name.length > 1) {
      if (state.addValue == "0.0" || state.addValue == "0.00") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Value")));
      } else {
        gst(state: state, gst: name, context: context);
      }
    } else {
      String vales = addValue(value: name, state: state, context: context);

      if (vales.endsWith("x") == true ||
          vales.endsWith("+") == true ||
          vales.endsWith("-") == true ||
          vales.endsWith("÷") == true ||
          vales.endsWith("%") == true ||
          vales.endsWith(".") == true) {
      } else {
        equal(state: state, context: context, values: vales, button: false);
      }
    }
  }

  String addValue({
    required String value,
    required GstCalculatorLoadedState state,
    required BuildContext context,
  }) {
    String values = textEditingController.text;

    if (state.button) {
      if (value == "+" || value == "-" || value == "x" || value == "÷") {
      } else {
        TextEditingController text = TextEditingController();
        textEditingController = text;
        cursor = 0;
      }
    }

    if (cursor != -1 || cursor != 0) {
      values = values.substring(0, cursor);
    }

    if (value == ".") {
      dotCount++;
    } else if (value == "+" || value == "-" || value == "x" || value == "÷") {
      dotCount = 0;
    }

    if (state.islastEqul) {
      if (value == "0" ||
          value == "00" ||
          value == "000" ||
          value == "+" ||
          value == "-" ||
          value == "x" ||
          value == "÷" ||
          value == "%" ||
          value == ".") {
        values = state.totalValue;
      } else {
        values = "0";
      }
    }

    if (value == "0" || value == "00" || value == "000") {
      lastvalue = value;
    }

    if (values.endsWith("x") ||
        values.endsWith("+") ||
        values.endsWith("-") ||
        values.endsWith("÷") ||
        values.endsWith(".")) {
      for (var e in opraters) {
        if (value == e) {
          values = values.substring(0, values.length - 1);
        }
      }
    } else if (values.endsWith("%")) {
      values = answerper;
    }

    if (values == "") {
      if (value == "0" ||
          value == "00" ||
          value == "000" ||
          value == "+" ||
          value == "-" ||
          value == "x" ||
          value == "÷" ||
          value == ".") {
      } else {
        values = value;
      }
    } else if (values.endsWith(".0")) {
      if (lastvalue != "0") {
        values = values.substring(0, values.indexOf("."));
        lastvalue = "abc";
      }
      values = values + value;
    } else if (value == "%") {
      values = values + value;
      answerper = pers(state: state, value: value);
    } else if (values.endsWith(".00")) {
      if (lastvalue != "00") {
        values = values.substring(0, values.indexOf("."));
        lastvalue = "abc";
      }
      values = values + value;
    } else if (values.endsWith(".000")) {
      if (lastvalue != "000") {
        values = values.substring(0, values.indexOf("."));
        lastvalue = "abc";
      }
      values = values + value;
    } else if (dotCount > 1) {
      if (value == ".") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Check Value")));
      } else {
        values = values + value;
      }
    } else {
      if (values == "0") {
        values = "";
      }
      values = values + value;
    }

    if (cursor != -1 || cursor != 0) {
      values = values + textEditingController.text.substring(cursor, textEditingController.text.length);
      cursor = cursor + 1;
    }

    TextEditingController text = TextEditingController(text: values);
    text.selection = TextSelection.collapsed(offset: cursor);
    textEditingController = text;

    if (value == "+" || value == "-" || value == "x" || value == "÷") {
      emit(state.copywith(
        addValue: values,
        textEditingController: text,
        cursorPos: cursor,
        totalValue: "",
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
        button: false,
        islastEqul: false,
      ));
    } else {
      emit(state.copywith(
        addValue: values,
        textEditingController: text,
        totalValue: answerper,
        cursorPos: cursor,
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
        button: false,
        islastEqul: false,
      ));
    }
    return values;
  }

  String pers({required GstCalculatorLoadedState state, required String value}) {
    String values = state.addValue;

    values = values + value;

    String tem = values.toString();
    String temsec = values.toString();
    int index = 0;

    String xyz = values;

    xyz = xyz.replaceAll('x', '*');
    xyz = xyz.replaceAll('÷', "/");

    for (int i = xyz.length - 1; i >= 1; i--) {
      if (xyz[i] == "+") {
        index = i;
        tem = values.substring(0, i);
        temsec = values.substring(i + 1, xyz.length);
        break;
      } else if (xyz[i] == "-") {
        index = i;
        tem = values.substring(0, i);
        temsec = values.substring(i + 1, xyz.length);
        break;
      } else if (xyz[i] == "*") {
        index = i;
        tem = values.substring(0, i);
        temsec = values.substring(i + 1, xyz.length);
        break;
      } else if (xyz[i] == "/") {
        index = i;
        tem = values.substring(0, i);
        temsec = values.substring(i + 1, xyz.length);
        break;
      } else {
        tem = "0";
        temsec = values;
      }
    }

    Parser p = Parser();
    Expression exp = p.parse(tem);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    temsec = temsec.replaceAll("%", "");

    String exps;
    if (xyz[index] == "+" || xyz[index] == "-") {
      exps = "$eval${xyz[index]}$temsec*$eval/100";
    } else if (xyz[index] == "*" || xyz[index] == "/") {
      exps = "$eval${xyz[index]}$temsec/100";
    } else {
      exps = "$temsec/100";
    }

    Expression ans = p.parse(exps);
    double answer = ans.evaluate(EvaluationType.REAL, cm);

    String answers = answer.toStringAsFixed(0);

    String finalAnswer = answer.toString();

    String check = finalAnswer.substring(finalAnswer.indexOf('.') + 1, finalAnswer.length);

    if (int.parse(check) > 0) {
      answers = answer.toStringAsFixed(2);
    }

    return answers.toString();
  }

  double equal({
    required GstCalculatorLoadedState state,
    required BuildContext context,
    required String values,
    required bool button,
  }) {
    String value = values.replaceAll('x', '*');
    value = value.replaceAll('÷', "/");
    value = value.replaceAll(',', "");

    if (value.endsWith("*") || value.endsWith("+") || value.endsWith("-") || value.endsWith("/")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Next Value")));
    }

    String totalValue = '';
    String answer = '';
    double eval = 0;
    if (values.indexOf("%") == -1) {
      Parser p = Parser();
      Expression exp = p.parse(value);
      ContextModel cm = ContextModel();
      eval = exp.evaluate(EvaluationType.REAL, cm);
      totalValue = eval.toStringAsFixed(0);
      answer = eval.toString();

      String check = "-1";
      if (answer.contains('.')) {
        check = answer.substring(answer.indexOf('.') + 1, answer.length);
      }

      if (int.parse(check) > 0) {
        totalValue = eval.toString();
      }
    } else {
      values = state.totalValue;
      eval = double.parse(state.totalValue);
    }

    if (button == true) {
      if (values.indexOf("%") != -1) {
        values = state.totalValue;
        totalValue = state.totalValue;
        eval = double.parse(state.totalValue);
      } else {
        values = totalValue;
      }
      TextEditingController text = TextEditingController(text: values);
      text.selection = TextSelection.collapsed(offset: values.length);
      textEditingController = text;
      totalValue = "";
      cursor = textEditingController.text.length;
    }

    if (values == "0") {
      totalValue = "";
    }

    if (value.indexOf("+") != -1 || value.indexOf("-") != -1 || value.indexOf("*") != -1 || value.indexOf("/") != -1) {
      emit(state.copywith(
        totalValue: totalValue,
        addValue: values,
        textEditingController: textEditingController,
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
        button: false,
        islastEqul: false,
      ));
    } else {
      emit(state.copywith(
        totalValue: "",
        addValue: values,
        textEditingController: textEditingController,
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
        button: false,
        islastEqul: false,
      ));
    }
    return eval;
  }

  String remove({required GstCalculatorLoadedState state, required BuildContext context}) {
    String vales = textEditingController.text;
    cursor = textEditingController.selection.base.offset;
    if (cursor != 0) {
      vales = vales.replaceRange(cursor - 1, cursor, '');
      cursor = cursor - 1;
    } else if (cursor == 0) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Not Remove")));
      null;
    } else if (vales.length > 1 && vales != "0") {
      vales = vales.substring(0, vales.length - 1);
      cursor = cursor - 1;
    } else {
      vales = "";
      cursor = 0;
    }
    TextEditingController text = TextEditingController(text: vales);
    text.selection = TextSelection.collapsed(offset: cursor);
    textEditingController = text;

    emit(
      state.copywith(
        addValue: vales,
        textEditingController: textEditingController,
        totalValue: "",
        csGst: "",
        csGstPer: "",
        iGst: "",
        iGstPer: "",
        totalWithGst: "",
      ),
    );
    return vales;
  }

  void gst({required GstCalculatorLoadedState state, required String gst, required BuildContext context}) {
    answerper = "";
    double value;
    if (state.iGst == "") {
      value = equal(state: state, context: context, values: state.addValue, button: false);
    } else {
      value = double.parse(state.totalWithGst);
    }

    String totalgst = gst.substring(0, gst.length - 1);
    Parser p = Parser();

    Expression exp = p.parse("$value * $totalgst / 200");
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    String csGst = eval.toStringAsFixed(0);
    String totalGst = (eval * 2).toStringAsFixed(0);
    String totalWithGst = (value + eval + eval).toStringAsFixed(0);
    String values = value.toStringAsFixed(0);

    String answer = eval.toString();
    String check = answer.substring(answer.indexOf('.') + 1, answer.length);

    String ansersec = (eval * 2).toString();
    String totalGstCheck = ansersec.substring(ansersec.indexOf('.') + 1, ansersec.length);

    String anserth = (value + eval + eval).toString();
    String totalWithGstCheck = anserth.substring(anserth.indexOf('.') + 1, anserth.length);

    String valueanswer = value.toString();
    String valuecheck = valueanswer.substring(valueanswer.indexOf('.') + 1, valueanswer.length);

    if (int.parse(check) > 0) {
      csGst = eval.toStringAsFixed(2);
    }

    if (int.parse(totalGstCheck) > 0) {
      totalGst = (eval * 2).toStringAsFixed(2);
    }

    if (int.parse(totalWithGstCheck) > 0) {
      totalWithGst = (value + eval + eval).toStringAsFixed(2);
    }

    if (int.parse(valuecheck) > 0) {
      values = value.toStringAsFixed(2);
    }

    TextEditingController text = TextEditingController(text: values);
    text.selection = TextSelection.collapsed(offset: cursor);
    textEditingController = text;

    emit(state.copywith(
      csGst: csGst,
      csGstPer: (int.parse(totalgst) / 2).toString(),
      iGstPer: totalgst,
      iGst: totalGst,
      totalWithGst: totalWithGst,
      totalValue: values,
      addValue: totalWithGst,
      button: false,
      islastEqul: true,
      textEditingController: textEditingController,
    ));
  }

  void textEdToetxt({required GstCalculatorLoadedState state, required String text}) {
    emit(state.copywith(addValue: text));
  }
}
