import 'dart:math';

import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  CodeBlock(this.text);

  final String text;

  String get getText {
    List<String> split = text.split("\n");

    var gutterDigits = (split.length + 1).toString().length;

    int lowestIndent;
    split.forEach((line) {
      if (lowestIndent == null) {
        lowestIndent = line.indexOf(RegExp("[^ ]"));
      } else {
        lowestIndent = min(line.indexOf(RegExp("[^ ]")), lowestIndent);
      }
    });

    var removedIndentSplit = split
        .asMap()
        .map((index, line) {
          var gutterNumber = (index + 1).toString();
          var gutterSpaces =
              List.generate(gutterDigits - gutterNumber.length, (_) => " ")
                  .join();
          var gutterText = gutterSpaces + gutterNumber;

          return MapEntry(
            index,
            "$gutterText | ${line.substring(lowestIndent)}",
          );
        })
        .values
        .toList();

    return removedIndentSplit.join("\n");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blueGrey.shade900,
          border: Border.all(color: Colors.white, width: 2.0, style: BorderStyle.solid)
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            getText,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto Mono",
            ),
          ),
        ),
      ),
    );
  }
}
