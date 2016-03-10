/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/// result callback
typedef void InputFileResult(List<int> result, String name, int size);

/**
 * File Input
 * - attaches content as binary data to record
 *
 * https://developer.mozilla.org/en-US/docs/Using_files_from_web_applications
 * https://www.w3.org/TR/html-markup/input.file.html
 */
class LInputFile extends LInput {

  /// Accept Image
  static const String ACCEPT_IMAGE = "image/*";

  static final Logger _log = new Logger("LInputFile");

  /// callback when there is a result
  InputFileResult inputFileResult;

  /// File Input
  LInputFile(String name, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super(name, EditorI.TYPE_FILE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue) {
  }

  /// File Input
  LInputFile.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super.from(dataColumn, EditorI.TYPE_FILE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue) {
    if (dataColumn.tableColumn.dataType == DataType.IMAGE) {
      accept = ACCEPT_IMAGE; // image/*;capture=camera
      capture = true;
    }
  }

  /// Init editor
  _initEditor(String type) {
    super._initEditor(type);
    input.style.color = "grey"; // file name
    //input.onInput.listen(onInputChange);
    input.onChange.listen(onInputChange);
  }

  /// This input element accepts a filename, which may only be programmatically set to the empty string
  void set value (String newValue) {
    if (value == null || value.isEmpty) {
      input.value = "";
    }
  }

  /// get accept
  String get accept => input.accept;
  /// set Accept
  void set accept (String newValue) {
    input.accept = newValue;
  }

  bool get capture => input.capture;
  void set capture (bool newValue) {
    input.capture = newValue;
  }

  // file uploaded
  void onInputChange(Event evt) {
    _log.info("onInputChange ${input.value}");
    if (input.files.isNotEmpty) {
      File file = input.files.first;
      var reader = new FileReader();
      reader.onLoad.listen((e) {
        Object resultObject = reader.result;
        if (resultObject is List<int>) {
          List<int> result = resultObject;
          double size = file.size / 1024;
          String info = "${file.name} ${size.toStringAsFixed(1)}k";
          _log.info("onInputChange ${info}");
          hint = info;
          if (data != null) {
            data.record.attachmentList.clear();
            data.record.attachmentNameList.clear();
            data.record.attachmentList.add(result);
            data.record.attachmentNameList.add(file.name);
          }
          if (inputFileResult != null)
            inputFileResult(result, file.name, file.size);
        } else {
          _log.warning("onInputChange ${resultObject}");
        }
      });
      // reader.readAsDataUrl(file);
      reader.readAsArrayBuffer(file);
    }
  } // onInputChange


} // LInputFile
