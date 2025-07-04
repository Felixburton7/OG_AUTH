import 'package:equatable/equatable.dart';

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

// get props is used to define the properties that should be considered when comparing instances of the NoParams class for equality. 
//This is part of the functionality provided by the Equatable package in Dart.

// Explanation of get props:
// 	•	Equatable Class: The Equatable class is a base class that helps you easily implement value equality in your classes. Normally, in Dart, two instances of a class are only considered equal if they are the exact same instance. By extending Equatable, you can define custom equality based on the values of certain properties.
// 	•	props Getter: The props getter is a list of properties that Equatable uses to determine whether two instances are equal. When you override this getter, you list the properties of your class that should be compared.