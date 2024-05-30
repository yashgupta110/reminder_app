import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/providers/reminder_provider.dart';
import 'package:reminder_app/screens/add_reminder_screen.dart';
import 'package:reminder_app/screens/edit_reminder_screen.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final reminders = reminderProvider.reminders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddReminderScreen(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
              iconSize: 30,
              iconDisabledColor: Theme.of(context).primaryColorDark,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              elevation: 16,
              dropdownColor: Theme.of(context).colorScheme.secondaryContainer,
              value: reminderProvider.filterPriority,
              items:
                  <String>['All', 'High', 'Medium', 'Low'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                reminderProvider.setFilterPriority(newValue!);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (ctx, index) {
                final reminder = reminders[index];
                return ListTile(
                  splashColor: Theme.of(context).colorScheme.secondaryFixed,
                  tileColor: Theme.of(context).colorScheme.secondaryFixed,
                  title: Text(
                    reminder.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    reminder.description,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      reminderProvider.deleteReminder(reminder.id);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditReminderScreen(reminder),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
