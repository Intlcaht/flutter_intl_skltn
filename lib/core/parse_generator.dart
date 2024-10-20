import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:intl_skltn/core/section_code_builder.dart';
import 'package:source_gen/source_gen.dart';

/// This abstract class, [ParserGenerator], provides
/// a generic framework for generating code based on annotations
///  and parsing elements. Subclasses must implement specific methods
/// to define the code generation behavior.
abstract class ParserGenerator<GlobalData, Data, Annotation>
    extends GeneratorForAnnotation<Annotation> {
  /// Generates code for the annotated elements in the given library.
  ///
  /// [oldLibrary]: The old library reader.
  /// [buildStep]: The build step being run.
  // @override
  // FutureOr<String> generate(
  //   LibraryReader oldLibrary,
  //   BuildStep buildStep,
  // ) async {
  //   final assetId =
  //       await buildStep.resolver.assetIdForElement(oldLibrary.element);
  //   if (await buildStep.resolver.isLibrary(assetId).then((value) => !value)) {
  //     return '';
  //   }

  //   final library = await buildStep.resolver.libraryFor(assetId);

  //   final values = StringBuffer();

  //   final globalData = parseGlobalData(library);

  //   var hasGeneratedGlobalCode = false;

  //   for (var element in library.topLevelElements.where(
  //       (e) => typeChecker.hasAnnotationOf(e, throwOnUnresolved: false))) {
  //     if (!hasGeneratedGlobalCode) {
  //       for (final value
  //           in generateForAll(globalData).map((e) => e.toString())) {
  //         values.writeln(value);
  //       }
  //       hasGeneratedGlobalCode = true;
  //     }

  //     final data = await parseElement(buildStep, globalData, element);
  //     if (data == null) continue;
  //     for (final value
  //         in generateForData(globalData, data).map((e) => e.toString())) {
  //       values.writeln(value);
  //     }
  //   }

  //   return values.toString();
  // }

  /// Generates code for all annotated elements.
  Iterable<Object> generateForAll(GlobalData globalData) sync* {}

  /// Parses global data from the given library.
  ///
  /// [library]: The library to parse global data from.
  GlobalData parseGlobalData(LibraryElement library);

  /// Parses data from the given element.
  ///
  /// [buildStep]: The build step being run.
  /// [globalData]: The global data parsed from the library.
  /// [element]: The element for which to parse data.
  FutureOr<Data> parseElement(
    BuildStep buildStep,
    GlobalData globalData,
    Element element,
  );

  /// Generates code for the given data and global data.
  ///
  /// [globalData]: The global data parsed from the library.
  /// [data]: The element-specific data to generate code for.
  Iterable<Object> generateForData(GlobalData globalData, Data data);

  @override
  Stream<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    // implemented for source_gen_test – otherwise unused
    final globalData = parseGlobalData(element.library!);
    final data = parseElement(buildStep, globalData, element);

    if (data == null) return;

    for (final value in generateForData(globalData, await data)) {
      yield value.toString();
    }
  }

  /// Generates code for the annotated variable element using [VariableSectionCodeBuilder].
  ///
  /// [variableSectionCodeBuilder]: The instance of VariableSectionCodeBuilder.
  /// [element]: The annotated variable element to generate code for.
  /// [annotation]: The constant reader for the annotation.
  /// [buildStep]: The build step being run.
  Stream<String> generateForVariableElement(
    VariableSectionCodeBuilder variableSectionCodeBuilder,
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async* {
    // implemented for source_gen_test – otherwise unused
    final globalData =
        variableSectionCodeBuilder.parseGlobalData(element, annotation);
    final data =
        variableSectionCodeBuilder.parseElement(buildStep, globalData, element);

    if (data == null) return;

    for (final value
        in variableSectionCodeBuilder.generateForData(globalData, await data)) {
      yield value.toString();
    }
  }
}
