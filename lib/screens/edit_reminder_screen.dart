import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/notification/notification_helper.dart';
import 'package:reminder_app/providers/reminder_provider.dart';

class EditReminderScreen extends StatefulWidget {
  final Reminder reminder;

  const EditReminderScreen(this.reminder, {super.key});

  @override
  EditReminderScreenState createState() => EditReminderScreenState();
}

class EditReminderScreenState extends State<EditReminderScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';

  @override
  void initState() {
    _titleController.text = widget.reminder.title;
    _descriptionController.text = widget.reminder.description;
    _selectedDate = widget.reminder.time;
    _selectedTime = TimeOfDay(
      hour: widget.reminder.time.hour,
      minute: widget.reminder.time.minute,
    );
    _priority = widget.reminder.priority;
    super.initState();
  }

  void _submitData() {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }
    final selectedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    final updatedReminder = Reminder(
      id: widget.reminder.id,
      title: _titleController.text,
      description: _descriptionController.text,
      time: selectedDateTime,
      priority: _priority,
    );
    Provider.of<ReminderProvider>(context, listen: false)
        .updateReminder(updatedReminder);
    DateTime dateTime = DateTime.parse(updatedReminder.id);
    int timestamp = dateTime.millisecondsSinceEpoch;
    NotificationHelper.scheduleNotification(
      timestamp,
      updatedReminder.title,
      updatedReminder.description,
      updatedReminder.time,
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: _selectDate,
                  child: const Text('Choose Date'),
                ),
                Text(
                  _selectedDate == null
                      ? 'No date chosen!'
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: _selectTime,
                  child: const Text('Choose Time'),
                ),
                Text(
                  _selectedTime == null
                      ? 'No time chosen!'
                      : _selectedTime!.format(context),
                ),
              ],
            ),
            DropdownButton<String>(
              value: _priority,
              items: <String>['High', 'Medium', 'Low'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
