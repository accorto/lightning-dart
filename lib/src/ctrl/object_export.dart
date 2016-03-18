/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Export
 */
class ObjectExport {

  static const String DOC = "https://support.accorto.com/support/solutions/articles/1000227558-export";

  static const String ID = "exp";

  static const String _TYPE_CSV = "csv";
  static const String _TYPE_JSON = "json";

  static final Logger _log = new Logger("ObjectExport");

  /// Modal
  final LModal _modal = new LModal(ID)
    ..large = true
    ..helpHref = DOC;

  /// selected Columns
  LPicklistMulti _columnSelect = new LPicklistMulti()
    ..label = objectExportColumns();
  LPicklist _formatPick = new LPicklist("format", idPrefix: ID)
    ..label =  objectExportFormat()
    ..required = true;
  LTextArea _preview = new LTextArea("preview", idPrefix: ID)
    ..label = objectExportPreview()
    ..cols = 50
    ..rows = 5
    ..readOnly = true;
  /// Download Anchor
  LButton _downloadButton = new LButton.neutralAnchorIcon("download",
      objectExportDownload(),
      new LIconUtility(LIconUtility.DOWNLOAD), idPrefix: ID);
  String _fileName;

  /// data source
  final Datasource datasource;
  int _selectedRecords = 0;

  /// Export
  ObjectExport(Datasource this.datasource) {

    String tagLine = objectExportRecords(datasource.recordList.length);
    _selectedRecords = 0;
    for (DRecord record in datasource.recordList) {
      if (record.isSelected)
        _selectedRecords++;
    }
    if (_selectedRecords > 0) {
      tagLine = objectExportRecordsSelected(_selectedRecords, datasource.recordList.length);
    }
    _modal.setHeader("${objectExportTitle()}: ${datasource.tableDirect.label}",
        tagLine: tagLine,
        icon: new LIconUtility(LIconUtility.DOWNLOAD));

    _fileName = LUtil.toVariableName(datasource.tableDirect.label);

    // columns
    HeadingElement h2 = new HeadingElement.h2()
      ..classes.add(LText.C_TEXT_HEADING__MEDIUM)
      ..text = objectExportSelectColumns();
    _modal.append(h2);

    // columns
    _columnSelect.options = OptionUtil.columnGridOptions(datasource.ui);
    _columnSelect.editorChange = onColumnEditorChange;
    _modal.append(_columnSelect.element);

    // format
    List<DOption> formatOptions = new List<DOption>();
    formatOptions.add(new DOption()
      ..value = _TYPE_CSV
      ..label = objectExportFile("CSV"));
    formatOptions.add(new DOption()
      ..value = _TYPE_JSON
      ..label = objectExportFile("Json"));
    _formatPick.dOptionList = formatOptions;
    _formatPick.value = _TYPE_CSV;
    _formatPick.editorChange = onFormatEditorChange;
    _modal.append(_formatPick.element);

    _modal.append(_preview.element);

    _modal.addFooterCancel();
    _modal.footer.append(_downloadButton.element);

    _updateDownload();
  } // ObjectExport

  String get id => _modal.id;

  void show() {
    _modal.showModal();
  }

  void onColumnEditorChange(String name, String newValue, DEntry entry, var details) {
    _updateDownload();
  }
  void onFormatEditorChange(String name, String newValue, DEntry entry, var details) {
    _updateDownload();
  }

  /// update download and preview
  void _updateDownload() {
    AnchorElement a = _downloadButton.element as AnchorElement;

    String format = _formatPick.value;
    a.download = "${_fileName}.${format}";

    String mediaType = "application/xml";
    String data = "";
    if (format == _TYPE_JSON) {
      mediaType = "application/json";
      data = _createJson();
    } else {
      mediaType = "text/csv";
      data = _createCsv();
    }
    //
    _preview.value = data;
    a.href = _toDataUrl(mediaType, data);
  } // updateDownload

  /**
   * https://tools.ietf.org/html/rfc2397
   * data:[<media type>][;charset=<character set>][;base64],<data>
   */
  String _toDataUrl(String mediaType, String plain) {
    // plain length: 4835
    // - encoded: 7707
    // String encoded = Uri.encodeComponent(plain);
    // return "data:${mediaType};charset=utf-8,${encoded}";
    // - base64: 6448
    // var bytes = UTF8.encode(plain);
    // var base64 = BASE64.encode(bytes);
    // https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/btoa
    String b64 = window.btoa(plain);
    // data:[<mediatype>][;base64],<data>
    return "data:${mediaType};charset=utf-8;base64,${b64}";
  } // toDataUrl

  /// create Json
  String _createJson() {
    List<DOption> options = _columnSelect.optionsSelected;
    if (options.isEmpty)
      return "{}";

    List<DColumn> columns = new List<DColumn>();
    for (DOption option in options) {
      DColumn column = DataUtil.getTableColumn(datasource.tableDirect, option.value);
      if (column != null) {
        columns.add(column);
      }
    }

    // lines
    List<Map<String,dynamic>> lines = new List<Map<String,dynamic>>();
    DataRecord data = new DataRecord(datasource.tableDirect, null);
    for (DRecord record in datasource.recordList) {
      if (_selectedRecords > 0 && !record.isSelected) {
        continue;
      }
      data.setRecord(record, 0);
      Map<String, dynamic> line = new Map<String, dynamic>();
      for (DColumn column in columns) {
        String columnName = column.name;
        String value = data.getValue(columnName);
        if (value == null || value.isEmpty) {
          continue;
        }
        DataType dt = column.dataType;
        if (dt == DataType.BOOLEAN) {
          line[columnName] = value;
        } else if (DataTypeUtil.isDate(dt)) {
          DateTime date = data.getValueAsDate(column.name);
          if (date == null) {
            line[columnName] = value; // conversion error
          } else {
            line[columnName] = date.toIso8601String();
          }
        } else if (DataTypeUtil.isNumber(dt)) {
          line[columnName] = value;
        } else {
          line[columnName] = value;
        }
      }
      lines.add(line);
    } // records

    return JSON.encode(lines);
  } // createJson

  /// create CSV
  String _createCsv() {
    List<DOption> options = _columnSelect.optionsSelected;
    if (options.isEmpty)
      return "";

    // heading
    StringBuffer sb = new StringBuffer();
    List<DColumn> columns = new List<DColumn>();
    for (DOption option in options) {
      DColumn column = DataUtil.getTableColumn(datasource.tableDirect, option.value);
      if (column != null) {
        columns.add(column);
        if (sb.length > 0)
          sb.write(",");
        sb
          ..write('"')
          ..write(column.name)
          ..write('"');
      }
    }
    sb.write("\n");

    // lines
    DataRecord data = new DataRecord(datasource.tableDirect, null);
    for (DRecord record in datasource.recordList) {
      if (_selectedRecords > 0 && !record.isSelected) {
        continue;
      }
      data.setRecord(record, 0);
      StringBuffer line = new StringBuffer();
      for (DColumn column in columns) {
        if (line.length > 0)
          line.write(",");
        String value = data.getValue(column.name);
        if (value == null || value.isEmpty) {
          line.write(" ");
          continue;
        }
        DataType dt = column.dataType;
        if (dt == DataType.BOOLEAN) {
          line.write(value);
        } else if (DataTypeUtil.isDate(dt)) {
          DateTime date = data.getValueAsDate(column.name);
          if (date == null) {
            line.write(value); // conversion error
          } else {
            line.write(date.toIso8601String());
          }
        } else if (DataTypeUtil.isNumber(dt)) {
          line.write(value);
        } else {
          line
            ..write('"')
            ..write(value)
            ..write('"');
        }
      }
      sb
        ..write(line)
        ..write("\n");
    } // lines
    return sb.toString();
  } // createCsv


  static String objectExportTitle() => Intl.message("Export", name: "objectExportTitle");
  static String objectExportRecords(int count) => Intl.message("$count records",
      name: "objectExportRecords", args:[count]);
  static String objectExportRecordsSelected(int selectedCount, int totalCount) => Intl.message("$selectedCount of $totalCount records",
      name: "objectExportRecordsSelected", args:[selectedCount, totalCount]);

  static String objectExportSelectColumns() => Intl.message("Select Columns", name: "objectExportSelectColumns");
  static String objectExportColumns() => Intl.message("Columns", name: "objectExportColumns");
  static String objectExportFormat() => Intl.message("Select Format", name: "objectExportFormat");
  static String objectExportFile(String type) => Intl.message("$type File",
      name: "objectExportFile", args:[type]);

  static String objectExportPreview() => Intl.message("Preview", name: "objectExportPreview");
  static String objectExportDownload() => Intl.message("Download", name: "objectExportDownload");


} // ObjectExport
