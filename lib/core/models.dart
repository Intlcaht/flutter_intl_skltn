class Data {
  final String name;
  final bool makeCollectionsImmutable;
  final bool genericArgumentFactories;
  const Data({
    required this.name,
    required this.makeCollectionsImmutable,
    required this.genericArgumentFactories,
  });
}

class GlobalData {
  final String elementName;
  final Map<String, dynamic> fields;
  const GlobalData({
    required this.elementName,
    required this.fields,
  });
}
