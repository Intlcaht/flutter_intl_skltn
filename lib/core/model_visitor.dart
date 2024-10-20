// ignore: depend_on_referenced_packages
import 'package:analyzer/dart/element/element.dart';
// ignore: depend_on_referenced_packages
import 'package:analyzer/dart/element/visitor.dart';

// A Dart class that extends SimpleElementVisitor for visiting elements in the code
class ModelVisitor extends SimpleElementVisitor {
  // Stores the name of the class being visited
  String className = '';

  // Stores information about fields in the form of a map (name -> type)
  Map<String, dynamic> fields = {};

  // Override method for visiting constructor elements
  @override
  visitConstructorElement(ConstructorElement element) {
    super.visitConstructorElement(element);
    // Extract the class name from the return type of the constructor
    final returnType = element.returnType.toString();
    className = returnType.replaceFirst('*', '');
  }

  /// !SECTION
  /// {
  ///  value: Type,
  ///  value2: Type2
  /// }
  // Override method for visiting field elements
  @override
  visitFieldElement(FieldElement element) {
    super.visitFieldElement(element);
    // Extract information about fields and add them to the fields map
    fields[element.name] = element.type.toString().replaceFirst('*', '');
  }
}
