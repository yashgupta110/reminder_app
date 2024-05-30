import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder.dart';

class ReminderProvider with ChangeNotifier {
  final  List<Reminder> _reminders = [];
  String _filterPriority = 'All';

  List<Reminder> get reminders {
    if (_filterPriority == 'All') {
      return [..._reminders];
    } else {
      return _reminders.where((rem) => rem.priority == _filterPriority).toList();
    }
  }

  String get filterPriority => _filterPriority;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void updateReminder(Reminder updatedReminder) {
    final index = _reminders.indexWhere((rem) => rem.id == updatedReminder.id);
    if (index >= 0) {
      _reminders[index] = updatedReminder;
      notifyListeners();
    }
  }

  void deleteReminder(String id) {
    _reminders.removeWhere((rem) => rem.id == id);
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }
}
