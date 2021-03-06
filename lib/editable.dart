// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library editable;

import 'package:flutter/material.dart';
import 'commons/helpers.dart';
import 'widgets/table_body.dart';
import 'widgets/table_header.dart';

class Editable extends StatefulWidget {
  /// Builds an editable table using predefined row and column counts
  /// Or using a row and header data set provided
  ///
  /// if no data is provided for [row] and [column],
  /// [rowCount] and [columnCount] properties must be set
  /// this will generate an empty table
  ///
  /// it is useful for rendering data from an API or to create a spreadsheet-like
  /// data table
  ///
  /// example:
  ///
  /// ```dart
  ///  Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///           Expanded(
  ///           flex: 1,
  ///           child: EdiTable(
  ///               showCreateButton: true,
  ///               tdStyle: TextStyle(fontSize: 20),
  ///               showSaveIcon: false,
  ///               borderColor: Colors.lightBlue,
  ///               columnCount: 4,
  ///               rowCount: 8
  ///              ),
  ///           ).
  ///         ]
  ///       ),
  ///   );
  /// }
  /// ```
  Editable(
      {Key key,
      this.columns,
      this.rows,
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.columnCount = 0,
      this.rowCount = 0,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 0.0,
      this.tdPaddingRight = 0.0,
      this.tdPaddingBottom = 10.0,
      this.thPaddingLeft = 10.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 0.0,
      this.thPaddingBottom = 0.0,
      this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 18,
      this.showSaveIcon = false,
      this.saveIcon = Icons.save,
      this.saveIconColor = Colors.black12,
      this.saveIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.showCreateButton = false,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.createButtonLabel})
      : super(key: key);

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else:
  /// Must be array of objects
  /// with the following keys: [title], [index] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'index': 1, 'key':'name'},
  ///   {"title":'Date', 'index': 2, 'key':'date'},
  ///   {"title":'Month', 'index': 3, 'key':'month'},
  ///   {"title":'Status', 'index': 4, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [index] represents a unique id for each column of type [int]
  ///
  /// [key] an identifyer preferably a short string
  final List columns;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with the following with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects should have its element positioned in same order as its column
  final List rows;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle tdStyle;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Table headers fontweight
  final FontWeight thWeight;

  /// Table headers fontSize
  final double thSize;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showSaveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData saveIcon;

  /// Color for the save Icon
  final Color saveIconColor;

  /// Size for the saveIcon
  final double saveIconSize;

  /// displays a button that adds a new row onPressed
  final bool showCreateButton;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon createButtonIcon;

  /// Color for the create new row button
  final Color createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape createButtonShape;

  /// Label for the create new row button
  final Widget createButtonLabel;

  ///[onSubmitted] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final ValueChanged<String> onSubmitted;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic> onRowSaved;

  @override
  _EditableState createState() => _EditableState(
      rows: this.rows,
      columns: this.columns,
      rowCount: this.rowCount,
      columnCount: this.columnCount);
}

class _EditableState extends State<Editable> {
  List rows, columns;
  int columnCount;
  int rowCount;

  _EditableState({this.rows, this.columns, this.columnCount, this.rowCount});

  @override
  void initState() {
    super.initState();
    _setup();
  }

  /// initial Setup of columns and row, sets count of column and row
  _setup() {
    rowCount = rows == null || rows.isEmpty ? rowCount : rows.length;
    columnCount =
        columns == null || columns.isEmpty ? columnCount : columns.length;
    columns = columns ?? columnBlueprint(columnCount, columns);
    rows = rows ?? rowBlueprint(rowCount, columns, rows);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Column(crossAxisAlignment: widget.createButtonAlign, children: [
            //Table Header
            createButton(),
            Container(
              padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: widget.borderColor,
                          width: widget.borderWidth))),
              child:
                  Row(mainAxisSize: MainAxisSize.min, children: _tableHeaders),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _tableRows,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  /// Builds saveIcon widget
  Widget _saveIcon(index) {
    return Flexible(
      fit: FlexFit.loose,
      child: Visibility(
        visible: widget.showSaveIcon,
        child: IconButton(
          padding: EdgeInsets.only(right: widget.tdPaddingRight),
          hoverColor: Colors.transparent,
          icon: Icon(
            widget.saveIcon,
            color: widget.saveIconColor,
            size: widget.saveIconSize,
          ),
          onPressed: () {
            int rowIndex = editedRows.indexWhere(
                (element) => element['row'] == index ? true : false);
            if (rowIndex != -1) {
              widget.onRowSaved(editedRows[rowIndex]);
            } else {
              widget.onRowSaved('no edit');
            }
          },
        ),
      ),
    );
  }

  /// Button for creating a new empty row
  Widget createButton() {
    return Visibility(
      visible: widget.showCreateButton,
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, bottom: 4),
        child: InkWell(
          onTap: () {
            rows = addOneRow(columns, rows);
            rowCount++;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: widget.createButtonColor ?? Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
              ],
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: widget.createButtonIcon ?? Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  /// Generates table columns
  List<Widget> get _tableHeaders =>
      List<Widget>.generate(columnCount + 1, (index) {
        return columnCount + 1 == (index + 1)
            ? iconColumn(widget.showSaveIcon, widget.thPaddingTop,
                widget.thPaddingBottom)
            : THeader(
                widthRatio: widget.columnRatio,
                thPaddingLeft: widget.thPaddingLeft,
                thPaddingTop: widget.thPaddingTop,
                thPaddingBottom: widget.thPaddingBottom,
                thPaddingRight: widget.thPaddingRight,
                headers: columns,
                thWeight: widget.thWeight,
                thSize: widget.thSize,
                index: index);
      });

  /// Temporarily holds all edited rows
  List editedRows = [];

  /// Generates table rows
  List<Widget> get _tableRows => List<Widget>.generate(rowCount, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnCount + 1, (rowIndex) {
            List list = rows[index].values.toList();
            var keys = rows[index].keys.toList();
            return columnCount + 1 == (rowIndex + 1)
                ? _saveIcon(index)
                : RowBuilder(
                    index: index,
                    col: keys[rowIndex],
                    trHeight: widget.trHeight,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    cellData: list[rowIndex],
                    tdPaddingLeft: widget.tdPaddingLeft,
                    tdPaddingTop: widget.tdPaddingTop,
                    tdPaddingBottom: widget.tdPaddingBottom,
                    tdPaddingRight: widget.tdPaddingRight,
                    tdAlignment: widget.tdAlignment,
                    tdStyle: widget.tdStyle,
                    onSubmitted: widget.onSubmitted,
                    widthRatio: widget.columnRatio,
                    onChanged: (value) {
                      ///checks if row has been edited previously
                      var result = editedRows.indexWhere((element) {
                        return element['row'] != index ? false : true;
                      });

                      ///adds a new edited data to a temporary holder
                      if (result != -1) {
                        editedRows[result][keys[rowIndex]] = value;
                      } else {
                        var temp = {};
                        temp['row'] = index;
                        temp[keys[rowIndex]] = value;
                        editedRows.add(temp);
                      }
                    },
                  );
          }),
        );
      });
}
