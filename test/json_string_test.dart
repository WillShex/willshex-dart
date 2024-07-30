import 'dart:io';

import 'package:test/test.dart';
import 'package:willshex/willshex.dart';

String? uglyJson, beautifulJson;

void getFiles() {
  if (uglyJson == null) {
    File file = File("./test/res/ugly.json");

    uglyJson = file.readAsStringSync();
  }

  if (beautifulJson == null) {
    File file = File("./test/res/beautiful.json");

    beautifulJson = file.readAsStringSync();
  }
}

void main() {
  group("JsonStringTest", () {
    test("testCleanJson", () {
      expect("[null,\"som e\",\"test, \\\" \"]",
          JsonUtils.cleanJson("[ null ,  \"som e\"   ,   \"test, \\\" \"]   "));
    });

    test("testCleanJson1", () {
      expect("[\"som e\",\"test, \\\" \"]",
          JsonUtils.cleanJson("[  ,  \"som e\"   ,   \"test, \\\" \"]   "));
    });

    test("testCleanJson2", () {
      expect(
          "{\"test\":[\"som e\",\"test, \\\" \"]}",
          JsonUtils.cleanJson(
              "{\"test\":[  ,  \"som e\"   ,   \"test, \\\" \"]   ,\"test1\" :  null, \"test3\":}"));
    });

    test("testCleanJson3", () {
      expect("{\"test\":\"hobbit: ses\"}",
          JsonUtils.cleanJson("{\"test\":\"hobbit: ses\"}"));
    });

    test("testCleanJson4", () {
      expect("{\"some\":\"test, \"}",
          JsonUtils.cleanJson("{\"some\":\"test, \"}"));
    });

    test("testCleanJson5", () {
      expect("{\"some\":\"test, \"}",
          JsonUtils.cleanJson("{\"some\"   :   \"test, \"}"));
    });

    test("testCleanJson6", () {
      expect("[\"som e\",\"test, \"]",
          JsonUtils.cleanJson("[\"som e\",\"test, \"]"));
    });

    test("testCleanJson7", () {
      expect("[\"som e\",\"test, \\\" \"]",
          JsonUtils.cleanJson("[\"som e\",\"test, \\\" \"]"));
    });

    test("testBeautifyJson", () {
      getFiles();
      expect(beautifulJson, JsonUtils.beautifyJson(uglyJson!));
    });

    test("testUglifyJson", () {
      getFiles();
      expect(uglyJson, JsonUtils.uglifyJson(beautifulJson!));
    });
  });
}
