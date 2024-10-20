// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// Retrieves the documentation comments of a parameter.
Future<String> documentationOfParameter(
  ParameterElement parameter,
  BuildStep buildStep,
) async {
  final builder = StringBuffer();

  final astNode = await tryGetAstNodeForElement(parameter, buildStep);

  for (Token? token = astNode.beginToken.precedingComments;
      token != null;
      token = token.next) {
    builder.writeln(token);
  }

  return builder.toString();
}

/// Attempts to retrieve the AST node for the given element.
Future<AstNode> tryGetAstNodeForElement(
  Element element,
  BuildStep buildStep,
) async {
  var library = element.library!;

  while (true) {
    try {
      final result = library.session.getParsedLibraryByElement(library)
          as ParsedLibraryResult?;

      return result!.getElementDeclaration(element)!.node;
    } on InconsistentAnalysisException {
      final assetId =
          await buildStep.resolver.assetIdForElement(element.library!);
      if (await buildStep.resolver.isLibrary(assetId).then((value) => !value)) {
        rethrow;
      }
      library = await buildStep.resolver.libraryFor(assetId);
    }
  }
}

final _upperCase = RegExp('[A-Z]');

/// Converts a string to kebab case.
String kebabCase(String input) => _fixCase(input, '-');

/// Converts a string to snake case.
String snakeCase(String input) => _fixCase(input, '_');

/// Converts a string to screaming snake case (uppercase snake case).
String screamingSnake(String input) => snakeCase(input).toUpperCase();

/// Converts a string to pascal case.
String pascalCase(String input) {
  if (input.isEmpty) {
    return '';
  }

  return input[0].toUpperCase() + input.substring(1);
}

String _fixCase(String input, String separator) =>
    input.replaceAllMapped(_upperCase, (match) {
      var lower = match.group(0)!.toLowerCase();

      if (match.start > 0) {
        lower = '$separator$lower';
      }

      return lower;
    });
