import 'dart:convert';

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) get metadata {
    if (_json // Modify from here...
        case {
          'metadata': {'title': String title, 'modified': String localModified},
        }) {
      return (title, modified: DateTime.parse(localModified));
    } else {
      throw const FormatException('Unexpected JSON');
    } // to here.
  }

  List<Block> getBlocks() {
    if (_json case {'blocks': List<dynamic> blocksJson}) {
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }
}

class Block {
  final String type;
  final String text;
  final bool checked;

  Block(this.type, this.text, this.checked);

  factory Block.fromJson(Map<String, dynamic> json) {
    if (json case {
      'type': String type,
      'text': String text,
      'checked': bool checked,
    }) {
      return Block(type, text, checked);
    } else if (json case {'type': String type, 'text': String text}) {
      return Block(type, text, false);
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
