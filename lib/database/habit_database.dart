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
Future<DateTime?>getFirstLaunchDate() async {



    final settings=await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
}



/*

CRUD x OPERATIONS

 */

//List of Habits

//CREATE - add a new habit

//READ - read saved habit from db

//UPDATE - check habit on  and off

//UPDATE - edit habit name

//DELETE - delete habit
}
