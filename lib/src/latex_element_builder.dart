import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

class LatexElementBuilder extends MarkdownElementBuilder {
  LatexElementBuilder({
    this.textStyle,
    this.textScaleFactor,
    this.onErrorFallback
  });

  /// The style to apply to the text.
  final TextStyle? textStyle;

  /// The text scale factor to apply to the text.
  final double? textScaleFactor;

  final Widget Function(FlutterMathException exception, String text)? onErrorFallback;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final String text = element.textContent;
    if (text.isEmpty) {
      return const SizedBox();
    }

    MathStyle mathStyle;
    switch (element.attributes['MathStyle']) {
      case 'text':
        mathStyle = MathStyle.text;
      case 'display':
        mathStyle = MathStyle.display;
      default:
        mathStyle = MathStyle.text;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.antiAlias,
      child: Math.tex(
        text,
        onErrorFallback: (exception) => onErrorFallback?.call(exception, text) ?? Math.defaultOnErrorFallback(exception),
        textStyle: textStyle,
        mathStyle: mathStyle,
        textScaleFactor: textScaleFactor,
      ),
    );
  }
}
