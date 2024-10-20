// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import 'imports.dart';

/// Extension methods for [DartType] to provide additional functionality.
extension DartTypeX on DartType {
  /// Checks if the Dart type is dynamic or invalid.
  bool get isDynamic2 {
    return this is DynamicType || this is InvalidType;
  }

  /// Checks if the Dart type is nullable.
  bool get isNullable {
    final that = this;
    if (that is TypeParameterType) {
      return that.bound.isNullable;
    }
    return isDynamic2 || nullabilitySuffix == NullabilitySuffix.question;
  }
}

/// Returns the [Element] for a given [DartType].
Element? _getElementForType(DartType type) {
  if (type is InterfaceType) {
    return type.element;
  }
  if (type is FunctionType) {
    return type.alias?.element;
  }
  return null;
}

/// Resolves a full type string from the provided [originLibrary] for the given [type].
///
/// This method resolves the full type string with potential import aliases.
String resolveFullTypeStringFrom(
  LibraryElement originLibrary,
  DartType type, {
  required bool withNullability,
}) {
  final owner = originLibrary.prefixes.firstWhereOrNull(
    (e) {
      return e.imports.any((l) {
        return l.importedLibrary!.anyTransitiveExport((library) {
          return library.id == _getElementForType(type)?.library?.id;
        });
      });
    },
  );

  String? displayType = type.getDisplayString(withNullability: withNullability);

  // Handle typedef cases
  if (type is FunctionType && type.alias?.element != null) {
    displayType = type.alias!.element.name;
    if (type.alias!.typeArguments.isNotEmpty) {
      displayType += '<${type.alias!.typeArguments.join(', ')}>';
    }
    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      displayType += '?';
    }
  }

  // Handle cases where type argument is not yet generated
  if (type is InterfaceType &&
      type.typeArguments.any((e) => e is InvalidType)) {
    final dynamicType = type.element.library.typeProvider.dynamicType;
    var modified = type;
    modified.typeArguments.replaceWhere(
      (t) => t is InvalidType,
      dynamicType,
    );
    displayType = modified.getDisplayString(withNullability: withNullability);
  }

  if (owner != null) {
    return '${owner.name}.$displayType';
  }

  return displayType ?? '';
}

/// Extension method on List<T> to replace elements based on a condition.
extension ReplaceWhereExtension<T> on List<T> {
  /// Replaces elements in the list that satisfy the condition with the provided replacement.
  void replaceWhere(bool Function(T element) test, T replacement) {
    for (var index = 0; index < length; index++) {
      if (test(this[index])) {
        this[index] = replacement;
      }
    }
  }
}
