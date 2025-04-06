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
    return switch (block) {
      HeaderBlock(:final text) => Text(
        text,
        style: Theme.of(context).textTheme.displayLarge,
      ),
      ParagraphBlock(:final text) => Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      CheckboxBlock(:final text, :final isChecked) => Row(
        children: [
          Checkbox(value: isChecked, onChanged: (_) {}),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    };
  }
}

String formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  return switch (difference) {
    Duration(inDays: 0) => 'Today',
    Duration(inDays: 1) => 'Tomorrow',
    Duration(inDays: -1) => 'Yesterday',
    Duration(inDays: final days) when days > 7 => '${days ~/ 7} weeks ago',
    Duration(inDays: final days) when days < -7 =>
      '${days ~/ 7} weeks from now',
    Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: final days) => '${days.abs()} days from now',
  };
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
          Center(child: Text('Last modified: ${formatTime(modified)}')),
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
