import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// A base class for generating code sections based on element data and annotations.
abstract class VariableSectionCodeBuilder<ElementData, Data> {
  /// Parses the global data from the provided element and annotation.
  ///
  /// [element]: The element to parse global data from.
  /// [annotation]: The constant reader for the annotation associated with the element.
  ElementData parseGlobalData(Element element, ConstantReader annotation);

  /// Parses the element-specific data for the given element.
  ///
  /// [buildStep]: The build step being run.
  /// [elementData]: The global data parsed from the element and annotation.
  /// [element]: The element for which to parse data.
  FutureOr<Data> parseElement(
    BuildStep buildStep,
    ElementData elementData,
    Element element,
  );

  /// Generates code sections for the given element-specific data.
  ///
  /// [globalData]: The global data parsed from the element and annotation.
  /// [data]: The element-specific data to generate code for.
  Iterable<Object> generateForData(ElementData elementData, Data data);

  /// Generates code sections for the annotated variable element.
  ///
  /// [element]: The annotated variable element to generate code for.
  /// [annotation]: The constant reader for the annotation.
  /// [buildStep]: The build step being run.
  Stream<String> generateForVariableElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    // implemented for source_gen_test – otherwise unused
    final globalData = parseGlobalData(element, annotation);
    final data = parseElement(buildStep, globalData, element);

    if (data == null) return;

    for (final value in generateForData(globalData, await data)) {
      yield value.toString();
    }
  }
}
