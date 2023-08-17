import 'package:flutter/material.dart';
import 'package:flutter_application_rating/my_app.dart';
import 'package:flutter_application_rating/result.dart';

void main() {
  runApp(const NaviPage());
}

class NaviPage extends StatefulWidget {
  const NaviPage({super.key});

  @override
  State<NaviPage> createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
  var items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      label: '오늘의 메뉴',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.check_box_outlined),
      label: '평가하기',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: '결과보기',
    ),
  ];

  dynamic page = const MyApp();
  var pages = [const MyApp(), const MyApp(), Result()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: page,
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
              page = pages[value];
            });
          },
        ),
      ),
    );
  }
}
