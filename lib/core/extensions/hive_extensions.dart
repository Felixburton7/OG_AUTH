import 'package:hive/hive.dart';

const _themeBoxName = "themeMode";

// This extension adds utility methods to the HiveInterface class,
// which is used for interacting with the Hive database.
extension ThemeModeBoxExtension on HiveInterface {
  // Method to open a Hive box for storing theme mode settings.
  Future<Box> openThemeModeBox() async {
    return await openBox(_themeBoxName);
  }

  // Getter to retrieve the opened Hive box for theme mode settings.
  Box get themeModeBox => box(_themeBoxName);
}


// GETTERs 
// 	•	Getter Definition: Box get themeModeBox => box(_themeBoxName);
// 	•	get themeModeBox: This defines a getter named themeModeBox.
// 	•	=> box(_themeBoxName);: This getter calls the box method with the _themeBoxName argument and returns the result. This gives you access to the Hive box with the name stored in _themeBoxName.

//How to use
// void someFunction(HiveInterface hive) {
//   // Using the getter to access the Hive box for theme mode
//   var box = hive.themeModeBox;
  
//   // Now you can work with the box, e.g., reading or writing data
// }

// //WITHOUT 
// void someFunction(HiveInterface hive) {
//   // Manually calling the method to retrieve the Hive box
//   var box = hive.box(_themeBoxName);
  
//   // Now you can work with the box, e.g., reading or writing data
// }