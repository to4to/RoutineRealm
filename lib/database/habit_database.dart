import "package:flutter/cupertino.dart";
import "package:isar/isar.dart";
import 'package:path_provider/path_provider.dart';
import "package:routine_realm/models/app_settings.dart";
import "package:routine_realm/models/habit.dart";

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

/*
   S E T U  P
 */

//INITIALIZE -Database

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

//Save first Date of Starting of App (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingettings = await isar.appSettings.where().findFirst();
    if (existingettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

//Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

/*

CRUD x OPERATIONS

 */

//List of Habits

  final List<Habit> currentHabits = [];

//CREATE - add a new habit
  Future<void> addHabit(String habitName) async {
    //create a new habit
    final newHabit = Habit()..name = habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //read from db
    readHabits();
  }

//READ - read saved habit from db
  Future<void> readHabits() async {
    //Fetch All Habits From db
    List<Habit> fetchHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    //update UI
    notifyListeners();
  }

//UPDATE - check habit on  and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find specific habit
    final habit = await isar.habits.get(id);

    //update completion status

    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed  -> add the current date to completedDays
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
//today
          final today = DateTime.now();

          //add the current date if it's not already in the list
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        //if habit not completed ->remove date from the list

        else {
//remove the current date if habit is not marked as not complete
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        //save the updated habit back to db

        await isar.habits.put(habit);
      });
    }
    //re-read from db
    readHabits();
  }

//UPDATE - edit habit name

  Future<void> updateHabitName(int id, String newName) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update name

    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;

        //save updated habit back to db

        await isar.habits.put(habit);
      });
    }

    //re -read from db

    readHabits();
  }

//DELETE - delete habit

  Future<void> deleteHabit(int id) async {
//perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
//re read from db

    readHabits();
  }
}
