// frontend/lib/main.dart

import 'package:flutter/material.dart';
// استدعاء شاشة الخط الزمني التي قمتِ بإنشائها
import 'screens/timeline_screen.dart'; 

void main() {
  runApp(const MyTripApp());
}

class MyTripApp extends StatelessWidget {
  const MyTripApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTrip App',
      debugShowCheckedModeBanner: false, // لإخفاء شريط الـ Debug الأحمر المزعج
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      // هنا نخبر التطبيق أن الشاشة الرئيسية هي شاشة الخط الزمني
      home: TimelineScreen(), 
    );
  }
}
