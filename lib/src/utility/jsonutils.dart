//
//  jsonutils.dart
//  willshex-dart
//
//  Created by William Shakour on April 25, 2020.
//  Copyright © 2020 WillShex Limited. All rights reserved.
//

class JsonUtils {
  /// Clean Json method will remove null properties, empty collections, empty dictionaries/types
  ///
  /// @param json
  /// @return
  static String cleanJson(String json) {
    return _cleanJson(json, true);
  }

  static String _cleanJson(String json, bool stripStrings) {
    List<String> values = <String>[];

    String stripped = json;

    if (stripStrings) {
      stripped = _strip(json, values);
    }

    String cleaned = stripped;
    do {
      stripped = cleaned;
      cleaned = cleaned.replaceAll("\"[a-zA-z]+[a-zA-Z0-9]*\":null", "");
      cleaned = cleaned.replaceAll(",,", ",");
      cleaned = cleaned.replaceAll(", ", ",");
      cleaned = cleaned.replaceAll("\\{,", "{");
      cleaned = cleaned.replaceAll(",\\}", "}");
      cleaned = cleaned.replaceAll("\\[,", "[");
      cleaned = cleaned.replaceAll(",\\]", "]");
      cleaned = cleaned.replaceAll(":\\{\\}", ":null");
      cleaned = cleaned.replaceAll(":\\{ \\}", ":null");
      cleaned = cleaned.replaceAll(":\\[\\]", ":[]");
      cleaned = cleaned.replaceAll(":\\[ \\]", ":{}");
      cleaned = cleaned.replaceAll("\\{\\}", "");
      cleaned = cleaned.replaceAll("\\[\\]", "");
      cleaned = cleaned.replaceAll(":,", ":null,");
      cleaned = cleaned.replaceAll(":\\}", ":null}");
    } while (stripped != cleaned);

    cleaned = _putBack(cleaned, values);

    if ("" == cleaned || "{}" == cleaned || "[]" == cleaned) {
      cleaned = "null";
    }

    return cleaned;
  }

  static String _strip(String json, List<String>? values) {
    if (values == null) return json;

    StringBuffer stripped = StringBuffer();

    bool inStringValue = false;
    bool escaped = false;
    int start = 0;
    String c;
    for (int i = 0; i < json.length; i++) {
      c = json[i];

      switch (c) {
        case '\"':
          if (inStringValue && !escaped) {
            inStringValue = false;
            stripped.write("*");
            values.add(json.substring(start, i + 1));
          } else if (!inStringValue) {
            inStringValue = true;
            start = i;
          }

          escaped = false;
          break;
        case ' ':
          escaped = false;
          break;
        case ':':
          if (!inStringValue) {
            if (stripped
                    .toString()
                    .substring(stripped.length - 1, stripped.length) ==
                "*") {
              final String replaced = stripped.toString().replaceRange(
                  stripped.length - 1,
                  stripped.length,
                  values[values.length - 1]);

              stripped.clear();
              stripped.write(replaced);

              values.removeAt(values.length - 1);
            }

            stripped.write(c);
          }

          escaped = false;
          break;
        case '\\':
          if (inStringValue) {
            escaped = true;
          }
          break;
        default:
          if (!inStringValue) {
            stripped.write(c);
          }
          escaped = false;
          break;
      }
    }

    return stripped.toString();
  }

  static String _putBack(String stripped, List<String> values) {
    StringBuffer? putBack;

    if (values.isNotEmpty) {
      putBack = StringBuffer();
      String c;
      int replaced = 0;
      for (int i = 0; i < stripped.length; i++) {
        c = stripped[i];

        if (c == "*") {
          putBack.write(values[replaced++]);
        } else {
          putBack.write(c);
        }
      }
    }

    return putBack == null ? stripped : putBack.toString();
  }

  /// Beautify json string indenting with 4 spaces and adding line ends with \n
  /// @param json ugly gson
  /// @return processed json
  static String beautifyJson(String json) {
    return _beautifyJson(json, "    ", "\n");
  }

  /**
	 * Beautify json string indenting
	 * @param json ugly gson
	 * @param level string to indet with
	 * @param line line end string
	 * @return processed json
	 */
  static String _beautifyJson(String json, String level, String line) {
    List<String> values = <String>[];
    String stripped = _strip(json, values);

    int length = stripped.length;
    String current;
    String indent = "";
    bool newLineAfter = true, newLineBefore = false;

    StringBuffer beautifulJson = StringBuffer();
    for (int i = 0; i < length; i++) {
      current = stripped[i];

      if (current == '[' || current == '{') {
        indent += level;
        newLineAfter = true;
      } else if (current == ']' || current == '}') {
        indent = indent.substring(0, indent.length - level.length);
        newLineBefore = true;
      } else if (current == ',') {
        newLineAfter = true;
      }

      if (newLineBefore) {
        beautifulJson.write(line);
        beautifulJson.write(indent);
        newLineBefore = false;
      }

      beautifulJson.write(current);

      if (newLineAfter) {
        beautifulJson.write(line);
        beautifulJson.write(indent);
        newLineAfter = false;
      }
    }

    return _putBack(beautifulJson.toString(), values);
  }

  static String uglifyJson(String json) {
    List<String> values = <String>[];
    String stripped = _strip(json, values);

    int length = stripped.length;
    String current;

    StringBuffer uglyJson = StringBuffer();
    for (int i = 0; i < length; i++) {
      current = stripped[i];

      if (current != ' ' && current != '\r' && current != '\n') {
        uglyJson.write(current);
      }
    }

    return _putBack(uglyJson.toString(), values);
  }
}
