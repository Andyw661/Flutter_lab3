import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});
  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, double> _tipsByDate = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadTipsFromFirestore();
  }

  Future<void> _loadTipsFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('tipHistory')
        .get();

    final Map<DateTime, double> tempData = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['tipAmount'] ?? 0.0).toDouble();
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null) continue;

      final date = timestamp.toDate();
      final day = DateTime.utc(date.year, date.month, date.day);
      tempData[day] = (tempData[day] ?? 0) + amount;
    }

    setState(() {
      _tipsByDate = tempData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _tipsByDate.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final tip = _tipsByDate[DateTime.utc(date.year, date.month, date.day)];
                  if (tip == null) return null;
                  return Positioned(
                    bottom: 1,
                    child: Text(
                      '\$${tip.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
