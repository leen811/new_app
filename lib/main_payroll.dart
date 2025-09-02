import 'package:flutter/material.dart';
import 'Ui/Profile/Payroll/payroll_deductions_page.dart';

void main() {
  runApp(const PayrollTestApp());
}

class PayrollTestApp extends StatelessWidget {
  const PayrollTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اختبار شاشة الرواتب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
      ),
      home: const PayrollDeductionsPage(),
    );
  }
}
