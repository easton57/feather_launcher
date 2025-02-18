import 'dart:async';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _currentTime = '00:00';

  void _updateTime() {
    setState(() {
      DateTime now = DateTime.now();
      String formattedTime =
          '${now.hour % 12 < 1 ? 12 : now.hour % 12}:${(now.minute) % 60 < 10 ? '0' : ''}${(now.minute) % 60}';
      _currentTime = formattedTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTime(); // initial update
    Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(fontSize: 64),
    );
  }
}
