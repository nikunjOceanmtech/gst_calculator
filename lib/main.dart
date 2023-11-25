import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gst_calculator/features/gst_calculator/presentation/pages/gst_calculator_screen.dart';
import 'package:gst_calculator/get_it.dart';

void main() {
  unawaited(init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenUtilInit(
        child: CalculatorScreen(),
      ),
    );
  }
}
