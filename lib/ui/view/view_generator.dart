// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:build/src/builder/build_step.dart';
import 'package:intl_antn/intl_antn.dart' show View;
import 'package:intl_skltn/core/model_visitor.dart';
import 'package:intl_skltn/core/models.dart';
import 'package:intl_skltn/core/parse_generator.dart';

class ViewGenerator extends ParserGenerator<GlobalData, Data, View> {
  @override
  Iterable<Object> generateForData(GlobalData globalData, Data data) sync* {
    final buffer = StringBuffer();
    buffer.writeln("/// Generated");

    /// add generation code

    yield [buffer.toString()];
  }

  @override
  FutureOr<Data> parseElement(
      BuildStep buildStep, GlobalData globalData, Element element) {
    return Data(
      name: globalData.elementName,
      makeCollectionsImmutable: true,
      genericArgumentFactories: false,
    );
  }

  @override
  GlobalData parseGlobalData(LibraryElement library) {
    final visitor = ModelVisitor();
    visitor.visitLibraryElement(library);
    return GlobalData(elementName: visitor.className, fields: visitor.fields);
  }
}
