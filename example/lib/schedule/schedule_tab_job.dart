import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'schedule_common.dart';
import 'package:freedom_table/freedom_table.dart';

class JobTab extends StatefulWidget {
  const JobTab({super.key});

  @override
  State<JobTab> createState() => _JobTabState();
}

class _JobTabState extends State<JobTab> {
  TextEditingController monthController = TextEditingController();
  bool isTableBodyDataLoading = true;

  late FreedomTable table;
  double minCellWidthInFlexMode = 100;
  double fixedColumnWidth1 = 80;
  double fixedColumnWidth2 = 100;
  double fixedColumnWidth3 = 50;
  Color tableBodyCellHoverColor = Color.fromRGBO(235, 240, 255, 1);

  // 休息理由
  List<Rest> restDatas = [];
  // 班次
  List<Time> timeDatas = [];
  // 网格 ： 岗位 + 人员
  List<Grid> gridDatas = [];
  // 岗位
  List<Area> areaDatas = [];
  // 人员
  List<User> userDatas = [];
  // 排班
  List<Schedule> scheduleDatas = [];

  List<Schedule> headerCellSchedules = [];
  List<List<Schedule?>> bodyCellSchedules = [];
  List<List<FreedomTableBodyCell>> bodyCellWidgets = [];
  List<Schedule> originalSchedules = [];
  List<Schedule> changedSchedules = [];

  @override
  void initState() {
    super.initState();

    // init rest data
    // UI非要在这里加「清空」
    restDatas.add(new Rest(restID: 'CLEAR', restName: '清空'));
    rests.forEach((rest) {
      restDatas.add(new Rest(restID: rest['restID'], restName: rest['restName']));
    });

    // init time data
    times.forEach((time) {
      if (time['isDeleted'] == null || time['isDeleted'] == false) {
        timeDatas.add(new Time(
          timeID: time['timeID'],
          timeName: time['timeName'],
          isDisabled: time['isDisabled'],
          canDelete: time['canDelete'],
          isDeleted: time['isDeleted'],
          timeStart: time['timeStart'],
          timeEnd: time['timeEnd'],
        ));
      }
    });

    // grids = [];
    // init grid data = area + user
    grids.forEach((grid) {
      List<Area> gridAreaDatas = [];
      grid['areas'].forEach((area) {
        Area newArea = new Area(
          gridID: grid['gridID'],
          gridName: grid['gridName'],
          areaID: area['areaID'],
          areaName: area['areaName'],
          areaWorkTimeDescription: area['areaWorkTimeDescription'],
        );
        gridAreaDatas.add(newArea);
        areaDatas.add(newArea);
      });
      List<User> gridUserDatas = [];
      grid['users'].forEach((user) {
        User newUser = new User(
          gridID: grid['gridID'],
          gridName: grid['gridName'],
          userID: user['userID'],
          userName: user['userName'],
          restLeftDays: user['restLeftDays'],
        );
        gridUserDatas.add(newUser);
        userDatas.add(newUser);
      });
      gridDatas.add(new Grid(
        gridID: grid['gridID'],
        gridName: grid['gridName'],
        areas: gridAreaDatas,
        users: gridUserDatas,
      ));
    });

    // init body schedules and header schedules
    scheduleDataGroupByAreaFromAPIOriginal.forEach((schedule) {
      try {
        User? user = schedule['userID'] != null && schedule['userID'] != '' ? findUser(schedule['userID']) : null;
        Grid? grid = schedule['areaID'] != null && schedule['areaID'] != '' ? findGrid(schedule['areaID']) : null;
        Area? area = schedule['areaID'] != null && schedule['areaID'] != '' ? findArea(schedule['areaID']) : null;
        Time? time = schedule['timeID'] != null && schedule['timeID'] != '' ? findTime(schedule['timeID']) : null;
        Rest? rest = schedule['restID'] != null && schedule['restID'] != '' ? findRest(schedule['restID']) : null;
        Schedule newSchedule = new Schedule(
          year: schedule['year'],
          month: schedule['month'],
          day: schedule['day'],
          weekday: isWeekday(schedule['weekday']) ? getWeekday(DateTime(schedule['year'], schedule['month'], schedule['day'])) : schedule['weekday'],
          userID: schedule['userID'] ?? "",
          userName: user?.userName ?? "",
          gridID: grid?.gridID ?? "",
          gridName: grid?.gridName ?? "",
          areaID: schedule['areaID'] ?? "",
          areaName: area?.areaName ?? "",
          timeID: schedule['timeID'] ?? "",
          timeName: time?.timeName ?? "",
          restID: schedule['restID'] ?? "",
          restName: rest?.restName ?? "",
        );
        scheduleDatas.add(newSchedule);

        // init headerCellSchedules
        if (schedule['month'] == DateTime.now().month) {
          insertIfNotExistHeaderCellSchedules(newSchedule);
        }
      } catch (e) {
        // do nothing, continue
      }
    });

    List originalHeaderCellSchdules = [];
    headerCellSchedules.forEach((schedule) {
      originalHeaderCellSchdules.add(Schedule.copy(schedule));
    });
    originalHeaderCellSchdules.forEach((schedule) {
      // 填充一个月内可能的间断的时间
      expandNewOneMonthHeaderCellSchedules(DateTime(schedule.year, schedule.month, schedule.day), false);
    });

    // 表格
    table = createTable(getHeaderCellWidgetsFromSchedules(), resetBodyCellWidgetsFromHeader());
  }

  Rest findRest(String restID) {
    return restDatas.firstWhere((rest) => rest.restID == restID);
  }

  Time findTime(String timeID) {
    return timeDatas.firstWhere((time) => time.timeID == timeID);
  }

  Area findArea(String areaID) {
    return areaDatas.firstWhere((area) => area.areaID == areaID);
  }

  User findUser(String userID) {
    return userDatas.firstWhere((user) => user.userID == userID);
  }

  Grid findGrid(String areaID) {
    Area area = findArea(areaID);
    return gridDatas.firstWhere((grid) => grid.gridID == area.gridID);
  }

  Schedule findHeaderScheduleByDate(int year, int month, int day) {
    return headerCellSchedules.firstWhere((schedule) => schedule.year == year && schedule.month == month && schedule.day == day);
  }

  Schedule getBodyNullSchedule(int rowIndex, int columnIndex, Schedule headerSchedule, Area area) {
    return new Schedule(
      year: headerSchedule.year,
      month: headerSchedule.month,
      day: headerSchedule.day,
      weekday: headerSchedule.weekday,
      userID: "",
      userName: "",
      gridID: area.gridID,
      gridName: area.gridName,
      areaID: area.areaID,
      areaName: area.areaName,
      timeID: "",
      timeName: "",
      restID: "",
      restName: "",
      rowIndex: rowIndex,
      columnIndex: columnIndex,
      isAdded: headerSchedule.isAdded,
    );
  }

  FreedomTable createTable(List<FreedomTableHeaderCell> headers, List<List<FreedomTableBodyCell>> bodys) {
    return FreedomTable(
      // key: GlobalKey(),
      minCellWidthInFlexMode: minCellWidthInFlexMode,
      theme: FreedomTableTheme(
        hoverColor: tableBodyCellHoverColor,
      ),
      headers: headers,
      initBodyCells: bodys,
      bodyUpdateFinished: () {
        // // 避免太快消失
        // Timer(Duration(milliseconds: 300), () {
        setState(() {
          isTableBodyDataLoading = false;
        });
        // });
      },
    );
  }

  int findHeaderIndexByHeaderSchedule(Schedule schedule) {
    try {
      Schedule founded = headerCellSchedules.firstWhere((element) => element.year == schedule.year && element.month == schedule.month && element.day == schedule.day);
      return headerCellSchedules.indexOf(founded);
    } catch (e) {
      // not found
      return -1;
    }
  }

  Schedule generateHeaderScheduleFromDate(DateTime date) {
    return new Schedule(
      year: date.year,
      month: date.month,
      day: date.day,
      weekday: getWeekday(date),
      userID: "",
      userName: "",
      gridID: "",
      gridName: "",
      areaID: "",
      areaName: "",
      timeID: "",
      timeName: "",
      restID: "",
      restName: "",
    );
  }

  void insertIfNotExistHeaderCellSchedules(Schedule schedule) {
    int headerIndex = findHeaderIndexByHeaderSchedule(schedule);
    if (headerIndex == -1) {
      // not found then insert
      int index = 0;
      for (; index < headerCellSchedules.length; index++) {
        Schedule headerCellSchedule = headerCellSchedules[index];
        if (isOutOfDateCheck(DateTime(headerCellSchedule.year, headerCellSchedule.month, headerCellSchedule.day), DateTime(schedule.year, schedule.month, schedule.day))) {
          break;
        }
      }
      headerCellSchedules.insert(index, schedule);
    }
  }

  void expandNewOneMonthHeaderCellSchedules(DateTime addedTime, [bool? isAdded]) {
    int currentMonth = addedTime.month;
    int currentDay = addedTime.day;
    for (int i = 0; i < currentDay; i++) {
      DateTime time = addedTime.add(Duration(days: -1 * i));
      Schedule schedule = generateHeaderScheduleFromDate(time);
      schedule.isAdded = isAdded == null ? true : isAdded;
      insertIfNotExistHeaderCellSchedules(schedule);
    }
    for (int i = 1; i <= 31 - currentDay; i++) {
      DateTime time = addedTime.add(Duration(days: i));
      if (time.month == currentMonth) {
        Schedule schedule = generateHeaderScheduleFromDate(time);
        schedule.isAdded = isAdded == null ? true : isAdded;
        insertIfNotExistHeaderCellSchedules(schedule);
      }
    }
  }

  Widget cellWidget(Widget child, [EdgeInsetsGeometry? padding]) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      child: child,
    );
  }

  // 单元格，请设置fontFamily,否则中文高度显示不正确
  Widget textColorWidget(String text, [Color? color]) {
    return Text(
      text,
      // overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "YaHei",
        fontSize: 14,
        color: color ?? Color.fromRGBO(51, 51, 51, 1),
      ),
    );
  }

  List<FreedomTableHeaderCell> getHeaderCellWidgetsFromSchedules() {
    List<FreedomTableHeaderCell> headerCellWidgets = [];
    headerCellWidgets = [
      FreedomTableHeaderCell(
        fixedWidth: fixedColumnWidth1,
        isFixedColumn: true,
        child: cellWidget(textColorWidget('网格名称')),
      ),
      FreedomTableHeaderCell(
        fixedWidth: fixedColumnWidth2,
        isFixedColumn: true,
        child: cellWidget(textColorWidget('岗位编号')),
      ),
      FreedomTableHeaderCell(
        fixedWidth: fixedColumnWidth3,
        isFixedColumn: true,
        child: cellWidget(textColorWidget('类型')),
      ),
    ];
    headerCellSchedules.forEach((schedule) {
      Color? specialColor = schedule.isOutOfDate
          ? Color.fromRGBO(153, 153, 153, 1)
          : isRedWeekday(schedule.weekday)
              ? Color.fromRGBO(250, 80, 60, 1)
              : null;
      headerCellWidgets.add(FreedomTableHeaderCell(
        flex: 1,
        child: cellWidget(Column(
          children: [
            textColorWidget(
              schedule.month.toString() + "月" + schedule.day.toString() + "日",
              specialColor,
            ),
            SizedBox(
              height: 6,
            ),
            textColorWidget(
              schedule.weekday.toString(),
              specialColor,
            )
          ],
        )),
      ));
    });
    return headerCellWidgets;
  }

  List<List<FreedomTableBodyCell>> resetBodyCellWidgetsFromHeader() {
    bodyCellWidgets = [];
    bodyCellSchedules = [];
    int rowIndex = -1;
    gridDatas.forEach((grid) {
      grid.areas.forEach((area) {
        rowIndex++;

        bodyCellWidgets.add([]);
        bodyCellSchedules.add([]);

        // 合并单元格计算
        int deferIndex = grid.areas.indexOf(area) == 0 ? 3 : 2;

        // 网格名称
        if (deferIndex == 3) {
          bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
            rowspan: grid.areas.length,
            child: cellWidget(textColorWidget(grid.gridName.toString())),
          ));
          bodyCellSchedules[rowIndex].add(null);
        }
        // 岗位编号
        bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
          child: cellWidget(textColorWidget(area.areaName.toString())),
        ));
        bodyCellSchedules[rowIndex].add(null);
        // 类型
        bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
          child: cellWidget(textColorWidget(area.areaWorkTimeDescription.toString())),
        ));
        bodyCellSchedules[rowIndex].add(null);
        // 日期
        scheduleDatas.forEach((schedule) {
          if (schedule.areaID == area.areaID) {
            try {
              Schedule findedHeaderSchedule = findHeaderScheduleByDate(schedule.year, schedule.month, schedule.day);
              int columnIndex = headerCellSchedules.indexOf(findedHeaderSchedule) + deferIndex;
              // 填充可能的未返回的间断的空数据
              int preLength = bodyCellWidgets[rowIndex].length;
              if (preLength < columnIndex + 1) {
                for (int i = preLength; i < columnIndex + 1; i++) {
                  if (i >= deferIndex) {
                    Schedule nullSchedule = getBodyNullSchedule(rowIndex, i, this.headerCellSchedules[i - deferIndex], area);
                    // nullSchedule.isAdded = true;
                    bodyCellWidgets[rowIndex].add(getBodyCellWidget(rowIndex, i, nullSchedule));
                    bodyCellSchedules[rowIndex].add(nullSchedule);
                  }
                }
              }
              // 有返回的数据
              schedule.rowIndex = rowIndex;
              schedule.columnIndex = columnIndex;

              bodyCellWidgets[rowIndex][columnIndex] = getBodyCellWidget(rowIndex, columnIndex, schedule);
              bodyCellSchedules[rowIndex][columnIndex] = schedule;
            } catch (e) {
              // not found right data from API
              // openWarnDialog(context, e.toString());
            }
          }
        });
        // 尾部填充可能的未返回的空数据
        int preLength = bodyCellWidgets[rowIndex].length;
        for (int i = preLength; i < headerCellSchedules.length + deferIndex; i++) {
          if (i >= deferIndex) {
            Schedule headerSchedule = headerCellSchedules[i - deferIndex];
            Schedule nullSchedule = getBodyNullSchedule(rowIndex, i, headerSchedule, area);
            // nullSchedule.isAdded = headerSchedule.isAdded;
            bodyCellWidgets[rowIndex].add(getBodyCellWidget(rowIndex, i, nullSchedule));
            bodyCellSchedules[rowIndex].add(nullSchedule);
          }
        }
      });
    });
    return bodyCellWidgets;
  }

  FreedomTableBodyCell getBodyCellWidget(int rowIndex, int columnIndex, Schedule schedule) {
    List<Widget> children = [];
    if (schedule.restID != '') {
      // 休息排班
      schedule.fontColor = Color.fromRGBO(51, 51, 51, 1);
      if (schedule.isOutOfDate) {
        schedule.fontColor = Color.fromRGBO(153, 153, 153, 1);
      }
      schedule.bgColor = Colors.transparent;
      if (schedule.isTapped) {
        // schedule.bgColor = Color.fromRGBO(235, 240, 255, 1);
        schedule.bgColor = Color.fromRGBO(250, 140, 0, 1);
        schedule.fontColor = Colors.white;
      }
      children = [
        textColorWidget(schedule.restName, schedule.fontColor),
      ];
    } else if (schedule.timeID != '') {
      // 正常排班
      schedule.fontColor = Colors.white;
      schedule.bgColor = Color.fromRGBO(0, 190, 90, 0.9);
      if (schedule.isTapped) {
        schedule.bgColor = Color.fromRGBO(250, 140, 0, 1);
      } else if (schedule.isOutOfDate) {
        schedule.bgColor = Color.fromRGBO(0, 190, 90, 0.5);
      }
      children = [
        textColorWidget(schedule.userName, schedule.fontColor),
        SizedBox(
          height: 6,
        ),
        textColorWidget(schedule.timeName, schedule.fontColor),
      ];
    } else if (schedule.isJobNull) {
      // 空白排班
      children = [
        Container(
          height: 60,
        )
      ];
    }
    return FreedomTableBodyCell(
      data: schedule,
      child: cellWidget(
        Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: schedule.bgColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ],
        ),
        EdgeInsets.all(0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 15)),
        // 操作

        // 班次说明
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color.fromRGBO(230, 230, 230, 1),
            ),
          ),
          child: Wrap(
            children: [
              Text(
                "班次说明：",
                style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...timeDatas.map((time) => Container(
                    padding: EdgeInsets.only(top: 1, bottom: 1, left: 6, right: 6),
                    margin: EdgeInsets.only(right: 15, bottom: 10),
                    decoration: BoxDecoration(
                      color: time.isDisabled ? Color.fromRGBO(250, 80, 60, 1) : Color.fromRGBO(250, 220, 50, 1),
                    ),
                    child: Text(
                      time.timeName + (time.isDisabled ? "（禁用）" : "") + " : " + time.timeStart + " - " + time.timeEnd,
                      style: TextStyle(
                        color: time.isDisabled ? Colors.white : Color.fromRGBO(102, 102, 102, 1),
                        fontSize: 14,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        // 表格
        Expanded(
          child: Stack(
            children: [
              Listener(
                onPointerSignal: (PointerSignalEvent event) {
                  if (event is PointerScrollEvent) {}
                },
                child: Container(
                  width: double.infinity,
                  child: table,
                ),
              ),
              if (isTableBodyDataLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
