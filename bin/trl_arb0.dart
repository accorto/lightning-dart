#!/usr/bin/env dart

/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

import 'dart:io';
import 'dart:convert';
import 'dart:async';


/**
 * Translate arb - parameters: dir language
 * pub run trl_arb $DIR de
 */
main(List<String> args) {
  String target = "/Users/jorg/Documents/BizPlatform/lightning/lightning-dart";
  String fileName = target + "/tool/translation/intl_messages.arb";
  if (args.length > 0)
    fileName = "${args[0]}/${TranslateArb.TRL_FILE}";
  String language = "de";
  if (args.length > 1)
    language = args[1];

  TranslateArb trl = new TranslateArb(language, fileName);
  trl.translate();
}


/**
 * Translate ARB File
 */
class TranslateArb {

  static const String TRL_FILE = "intl_messages.arb";
  static const String API_KEY="---YourKeyComesHere---";

  final String sourceLanguage = "en";
  final String targetLanguage;

  // input
  final String fileName;
  String fileNameOut;

  // translate map
  Map<String, dynamic> map;

  TranslateArb(String this.targetLanguage, String this.fileName) {
    File theFile = new File(fileName);
    String jsonString = theFile.readAsStringSync();
    map = JSON.decode(jsonString);
    //
    fileNameOut = fileName.replaceAll(TRL_FILE, "messages_${targetLanguage}.arb");
  } // TranslateArb

  /**
   * Translate Map
   */
  void translate() {
    /*
    "pagerInfo":"{record} of {total}",
    "@pagerInfo":{
      "type":"text",
      "placeholders":{
        "record":{
        },
        "total":{
        }
      }
    },
    */
    List<Future<bool>> processes = new List<Future<bool>>();
    map.forEach((String key, value){
      if (!key.contains("@")) {
        if (value.contains("{}"))
          print("${key}=${value} xxxx");
        processes.add(doTranslate(key, value));
      }
    });
    // wait for complete
    Future.wait(processes)
    .then((_){
      print(fileNameOut);
      File outFile = new File(fileNameOut);
      outFile.writeAsString(JSON.encode(map));
    });
  } // translate

  /**
   * https://cloud.google.com/translate/v2/using_rest
   */
  Future<bool> doTranslate(String key, String value) {
    Completer<bool> c = new Completer<bool>();
    HttpClient client = new HttpClient();
    client.getUrl(getUri(value))
    .then((HttpClientRequest request) {
      return request.close();
    })
    .then((HttpClientResponse response) {
      StringBuffer json = new StringBuffer();
      response.transform(UTF8.decoder).listen((contents){
        json.write(contents);
      }, onDone: () {
        String translation = processGoogleResponse(json.toString());
        if (translation != null)
          map[key] = translation;
        client.close();
        c.complete(translation != null);
      });
    });
    return c.future;
  } // doTranslate

  /**
   * Get Translation from Google Response
   * https://developers.google.com/translate/v2/using_rest
   */
  String processGoogleResponse(String response) {
    try {
      var json = JSON.decode(response);
      var data = json["data"];
      if (data == null) {
        print(response);
        return null;
      }
      var translations = data["translations"];
      var translation = translations[0];
      var text = translation["translatedText"];
      // print("${phrase} = ${text}");
      return text;
    }
    catch(e) {
      print(e);
      print(response);
    }
    return null;
  } // processGoogleResponse

  /**
   * https://www.googleapis.com/language/translate/v2?key=INSERT-YOUR-KEY&q=hello%20world&source=en&target=de
   */
  Uri getUri(String phrase) {
    Map<String, String> queryParameters = new Map<String,String>();
    queryParameters["key"] = API_KEY;
    queryParameters["q"] = phrase;
    queryParameters["source"] = sourceLanguage;
    queryParameters["target"] = targetLanguage;
    return new Uri.https("www.googleapis.com", "/language/translate/v2", queryParameters);
  }

} // TranslateArb
