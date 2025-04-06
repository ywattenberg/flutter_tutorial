import 'dart:ffi';

import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(document: Document()),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({required this.block, super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle;
    switch (block.type) {
      case 'h1':
        textStyle = Theme.of(context).textTheme.titleLarge;
      case 'p' || 'checkbox':
        textStyle = Theme.of(context).textTheme.bodyLarge;
      case _:
        textStyle = Theme.of(context).textTheme.bodyMedium;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Text(block.text, style: textStyle),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({required this.document, super.key});

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.metadata;
    final blockList = document.getBlocks();

    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title))),
      body: Column(
        children: [
          Center(child: Text('Last modified: $modified')),
          Expanded(
            child: ListView.builder(
              itemCount: blockList.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blockList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
