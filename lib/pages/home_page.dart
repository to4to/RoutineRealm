import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:routine_realm/components/my_drawer.dart';
import 'package:routine_realm/database/habit_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //textController

  final TextEditingController textEditingController = TextEditingController();

  //create New Habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Create New Habit"),
        ),
        actions: [
          //save button
          MaterialButton(onPressed: () {
            //get new habit name
            String newHabitName = textEditingController.text;

            //save to db
            context.read<HabitDatabase>().addHabit(newHabitName);
            //pop box
            Navigator.pop(context);
            //clear controller

            textEditingController.clear();
          }),

          //cancel button
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
