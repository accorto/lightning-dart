/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Range Editor - min/max/step
 */
class LInputRange
    extends LInput {


  /// Left Side Element
  final SpanElement _text = new SpanElement()
    ..classes.add(LForm.C_INPUT__PREFIX);

  /// Range Input
  LInputRange(String name, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super(name, EditorI.TYPE_RANGE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue);

  /// Range Input
  LInputRange.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super.from(dataColumn, EditorI.TYPE_RANGE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue);


  /// initialize listeners
  @override
  void _initEditor(String type) {
    super._initEditor(type);
  }

  /// Left Side Element
  Element getLeftElement() => _text;

  @override
  void set value (String newValue) {
    input.value = newValue;
    _text.text = input.value;
  }

  /// int value or 0
  int get valueAsInt {
    String s = input.value;
    if (s != null && s.isNotEmpty)
      return int.parse(s, onError: (s){return 0;});
    return 0;
  }
  void set valueAsInt (int newValue) {
    input.value = newValue.toString();
    _text.text = input.value;
  }

    /// Set Min - Max - Step
  void setMinStepMax(int min, int step, int max) {
    input.min = min.toString();
    input.step = step.toString();
    input.max = max.toString();
    _setTextTitle();
  }

  void set min (String newValue) {
    input.min = newValue;
    _setTextTitle();
  }
  void set max (String newValue) {
    input.max = newValue;
    _setTextTitle();
  }
  String get step => input.step;
  void set step (String newValue) {
    input.step = newValue;
    _setTextTitle();
  }

  // set title
  void _setTextTitle() {
    input.title = "${input.min} ..(${input.step}).. ${input.max}";
  }

  // fix value
  bool doValidate() {
    bool result = super.doValidate();
    _text.text = input.value;
    return result;
  }

} // LInputRange
