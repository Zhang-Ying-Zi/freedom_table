import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freedom_table/freedom_table.dart';
import 'schedule_common.dart';

class ScheduleOrder extends StatefulWidget {
  const ScheduleOrder({super.key});

  @override
  State<ScheduleOrder> createState() => _ScheduleOrderState();
}

class _ScheduleOrderState extends State<ScheduleOrder> {
  late FreedomTable table;

  @override
  void initState() {
    super.initState();
    table = FreedomTable(
      headers: [
        FreedomTableHeaderCell(
          flex: 1,
          child: headerCell('班次', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          flex: 1,
          child: headerCell('考勤时间', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          fixedWidth: 200,
          child: headerCell('当前状态', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          fixedWidth: 200,
          child: headerCell('操作', Alignment.centerLeft),
        ),
      ],
      initBodyCells: getPageData(1, 0),
    );
  }

  // header单元格，请设置fontFamily,否则中文高度显示不正确
  Widget headerCell(String name, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: "YaHei",
        ),
      ),
    );
  }

  // body单元格，请设置fontFamily,否则中文高度显示不正确
  Widget rowCell(String name, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: "YaHei",
        ),
      ),
    );
  }

  Widget rowCellWidget(Widget child, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      alignment: align ?? Alignment.center,
      child: child,
    );
  }

  // 获取分页数据
  List<List<FreedomTableBodyCell>> getPageData(totalPages, currentPageIndex, [List? dataFromAPI]) {
    List<List<FreedomTableBodyCell>> bodyCells = [];
    times.forEach((data) {
      if (data['isDeleted'] == false) {
        bodyCells.add([
          FreedomTableBodyCell(
            child: rowCell(data['timeName'], Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell(data['timeStart'] + "-" + data['timeEnd'], Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell(data['isDisabled'] == true ? '禁用' : '启用', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 1,
                  height: 14,
                  decoration: BoxDecoration(color: Color.fromRGBO(80, 120, 240, 1)),
                ),
              ],
            ),
          )),
          // FreedomTableBodyCell(
          //   child: rowCellWidget(
          //       CupertinoSwitch(
          //         activeColor: Color.fromRGBO(80, 120, 240, 1),
          //         value: data['canDelete'],
          //         onChanged: (onChanged) {
          //           data['canDelete'] = onChanged;
          //           table.updateBody(getPageData(totalPages, currentPageIndex, dataFromAPI));
          //         },
          //       ),
          //       Alignment.centerLeft),
          // ),
        ]);
      }
    });
    return bodyCells;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  //     decoration: BoxDecoration(
                  //       color: Color.fromRGBO(255, 240, 240, 1),
                  //       border: Border.all(
                  //         color: Color.fromRGBO(250, 200, 200, 1),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       "注意：已有班次不可编辑、删除，只可禁用、启用。",
                  //       style: TextStyle(
                  //         fontSize: 14,
                  //         color: Color.fromRGBO(250, 80, 60, 1),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  ElevatedButton.icon(
                    label: Text(
                      '新增',
                      style: TextStyle(
                        color: Color.fromRGBO(80, 120, 240, 1),
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(0)),
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                      fixedSize: MaterialStateProperty.resolveWith((states) => Size(78, 32)),
                    ),
                    onPressed: () {
                      openDialog(context, ScheduleOrderAdd());
                    },
                    icon: Icon(
                      Icons.add,
                      color: Color.fromRGBO(80, 120, 240, 1),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: table,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ScheduleOrderAdd extends StatefulWidget {
  const ScheduleOrderAdd({super.key});

  @override
  State<ScheduleOrderAdd> createState() => _ScheduleOrderAddState();
}

class _ScheduleOrderAddState extends State<ScheduleOrderAdd> {
  TextEditingController nameController = TextEditingController();
  TextEditingController starttimeController = TextEditingController();
  TextEditingController endtimeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    starttimeController.dispose();
    endtimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScheduleDialog(
      title: '新增班次',
      width: 420,
      onConfirmPressed: () {
        print(nameController.text);
        print(starttimeController.text);
        print(endtimeController.text);
      },
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                title('班次名称   '),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: textFormField(nameController),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Container(
            child: Row(
              children: [
                title('上下班时间'),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(child: timeTextFormField(context, starttimeController, '开始时间')),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text("-"),
                ),
                Expanded(child: timeTextFormField(context, endtimeController, '结束时间')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Row(
      children: [
        Text(
          '*',
          style: TextStyle(
            color: Color.fromRGBO(250, 80, 60, 1),
            fontSize: 14,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(102, 102, 102, 1),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
