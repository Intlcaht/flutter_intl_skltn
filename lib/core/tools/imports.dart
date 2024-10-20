// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';

/// Extension methods for [LibraryElement] to help with finding transitive exports.
extension LibraryHasImport on LibraryElement {
  /// Finds a transitive export where the provided [visitor] function returns true.
  LibraryElement? findTransitiveExportWhere(
    bool Function(LibraryElement library) visitor,
  ) {
    if (visitor(this)) return this;

    final visitedLibraries = <LibraryElement>{};
    LibraryElement? visitLibrary(LibraryElement library) {
      if (!visitedLibraries.add(library)) return null;

      if (visitor(library)) return library;

      for (final export in library.exportedLibraries) {
        final result = visitLibrary(export);
        if (result != null) return result;
      }

      return null;
    }

    for (final import in exportedLibraries) {
      final result = visitLibrary(import);
      if (result != null) return result;
    }

    return null;
  }

  /// Checks if any transitive export satisfies the provided [visitor] function.
  bool anyTransitiveExport(
    bool Function(LibraryElement library) visitor,
  ) {
    return findTransitiveExportWhere(visitor) != null;
  }
}
