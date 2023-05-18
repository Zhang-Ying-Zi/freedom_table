import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'schedule_common.dart';
import 'package:freedom_table/freedom_table.dart';
import 'schedule_manage_edit.dart';

class ManTab extends StatefulWidget {
  const ManTab({super.key});

  @override
  State<ManTab> createState() => _ManTabState();
}

class _ManTabState extends State<ManTab> {
  TextEditingController monthController = TextEditingController();
  bool isTableBodyDataLoading = false;

  late FreedomTable table;
  // GlobalKey tableKey = GlobalKey();
  double minCellWidthInFlexMode = 100;
  double fixedColumnWidth1 = 80;
  double fixedColumnWidth2 = 70;
  double fixedColumnWidth3 = 50;
  Color tableBodyCellHoverColor = Color.fromRGBO(235, 240, 255, 1);

  bool isRightMouseClickInTableCell = false;
  double rightClickTopInTable = 0;
  double rightClickLeftInTable = 0;
  int hoverRightMenuItemIndex = -1;

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

  int preTappedRowIndex = -1;
  int preTappedColumnIndex = -1;
  Schedule? tappedSchedule;
  Schedule? tappedScheduleSource;

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
    scheduleDataGroupByUserFromAPIOriginal.forEach((schedule) {
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
        insertIfNotExistHeaderCellSchedules(newSchedule);
      } catch (e) {
        // do nothing, continue
      }
    });

    List originalHeaderCellSchdules = [];
    headerCellSchedules.forEach((schedule) {
      originalHeaderCellSchdules.add(Schedule.copy(schedule));
    });
    originalHeaderCellSchdules.forEach((schedule) {
      // 填充一周内可能的间断的时间
      expandNewOneWeekHeaderCellSchedules(DateTime(schedule.year, schedule.month, schedule.day), false);
    });

    // 表格
    table = createTable(getHeaderCellWidgetsFromSchedules(), resetBodyCellWidgetsFromHeader());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
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

  Schedule findBodyScheduleByUser(int year, int month, int day, String userID) {
    return scheduleDatas.firstWhere((schedule) => schedule.userID == userID && schedule.year == year && schedule.month == month && schedule.day == day);
  }

  Schedule findBodyScheduleByArea(int year, int month, int day, String areaID) {
    return scheduleDatas.firstWhere((schedule) => schedule.areaID == areaID && schedule.year == year && schedule.month == month && schedule.day == day);
  }

  Schedule findHeaderScheduleByDate(int year, int month, int day) {
    return headerCellSchedules.firstWhere((schedule) => schedule.year == year && schedule.month == month && schedule.day == day);
  }

  int getIndexInSchedules(List<Schedule> sourceSchedules, Schedule checkedSchedule) {
    try {
      return sourceSchedules.indexOf(sourceSchedules.firstWhere(
          (schedule) => schedule.year == checkedSchedule.year && schedule.month == checkedSchedule.month && schedule.day == checkedSchedule.day && schedule.userID == checkedSchedule.userID));
    } catch (e) {
      return -1;
    }
  }

  // 修改的
  bool isScheduleEdited(Schedule checkedSchedule) {
    int index = getIndexInSchedules(originalSchedules, checkedSchedule);
    if (index == -1) {
      return false;
    } else {
      return !checkedSchedule.isSame(originalSchedules[index]);
    }
  }

  // 新增的排班
  bool isScheduleRealAdded(Schedule checkedSchedule) {
    return checkedSchedule.isAdded && !checkedSchedule.isManNull;
  }

  // 修改的新增的排班
  bool isScheduleRealAddedAndEdited(Schedule checkedSchedule) {
    return isScheduleRealAdded(checkedSchedule) && isScheduleEdited(checkedSchedule);
  }

  // 单纯修改原有的排班
  bool isScheduleJustEdited(Schedule checkedSchedule) {
    if (checkedSchedule.isAdded) return false;
    return isScheduleEdited(checkedSchedule);
  }

  bool isScheduleChanged(Schedule checkedSchedule) {
    return isScheduleJustEdited(checkedSchedule) || isScheduleRealAdded(checkedSchedule) || isScheduleRealAddedAndEdited(checkedSchedule);
  }

  // ERROR : 新增后修改再CLEAR
  // before
  void updateOriginalSchedules(Schedule checkedSchedule) {
    if (getIndexInSchedules(originalSchedules, checkedSchedule) != -1) return;
    if (!isScheduleChanged(checkedSchedule)) {
      originalSchedules.add(Schedule.copy(checkedSchedule));
    }
  }

  // after
  void updateChangedSchedules(Schedule changedSchedule) {
    if (isScheduleChanged(changedSchedule)) {
      // 改变的
      // WARNING 目前排除新增的空白排班
      setState(() {
        int deleteIndex = getIndexInSchedules(changedSchedules, changedSchedule);
        if (deleteIndex != -1) changedSchedules.removeAt(deleteIndex);
        changedSchedules.add(changedSchedule);
      });
    } else if (getIndexInSchedules(originalSchedules, changedSchedule) != -1) {
      // 改回原来的
      setState(() {
        int deleteIndex = getIndexInSchedules(changedSchedules, changedSchedule);
        if (deleteIndex != -1) changedSchedules.removeAt(deleteIndex);
      });
    }
  }

  bool canResave() {
    if (changedSchedules.length > 0) {
      return true;
    } else {
      // 有全新新增一周空白数据的
      for (var i = 0; i < bodyCellSchedules.length; i++) {
        for (var j = 0; j < bodyCellSchedules[i].length; j++) {
          if (bodyCellSchedules[i][j] != null && bodyCellSchedules[i][j]!.isAdded) {
            return true;
          }
        }
      }
      return false;
    }
  }

  Schedule getBodyNullSchedule(int rowIndex, int columnIndex, Schedule headerSchedule, User user) {
    return new Schedule(
      year: headerSchedule.year,
      month: headerSchedule.month,
      day: headerSchedule.day,
      weekday: headerSchedule.weekday,
      userID: user.userID,
      userName: user.userName,
      gridID: user.gridID,
      gridName: user.gridName,
      areaID: "",
      areaName: "",
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
    // tableKey = GlobalKey();
    return FreedomTable(
      minCellWidthInFlexMode: minCellWidthInFlexMode,
      theme: FreedomTableTheme(
        hoverColor: tableBodyCellHoverColor,
      ),
      headers: headers,
      initBodyCells: bodys,
      bodyCellOnTap: bodyCellOnTap,
      bodyCellOnSecondaryTap: bodyCellOnSecondaryTap,
      bodyUpdateFinished: () {
        print("finished");
        // 避免太快消失
        // Timer(Duration(milliseconds: 300), () {
        setState(() {
          isTableBodyDataLoading = false;
        });
        // });
      },
    );
  }

  // 左击
  void bodyCellOnTap(cell, left, top, width, height, scrollLeft, scrollTop, totalScrollWidth, totalScrollHeight) {
    try {
      tappedSchedule = cell.data as Schedule;
      // print(tappedSchedule);
      if (tappedSchedule!.isOutOfDate) {
        openWarnDialog(context, "今天之前的排班无法编辑！");
      } else {
        Rest? choosedRest = tappedSchedule!.restID != '' ? findRest(tappedSchedule!.restID) : null;
        Area? choosedArea = tappedSchedule!.areaID != '' ? findArea(tappedSchedule!.areaID) : null;
        Time? choosedTime = tappedSchedule!.timeID != '' ? findTime(tappedSchedule!.timeID) : null;
        if (choosedTime != null && choosedTime.isDisabled) {
          choosedTime = null;
        }
        openDialog(
          context,
          ScheduleManageEdit(
            restDatas: restDatas,
            gridDatas: gridDatas,
            timeDatas: timeDatas,
            schedule: tappedSchedule!,
            choosedRest: choosedRest,
            choosedArea: choosedArea,
            choosedTime: choosedTime,
          ),
        ).then((result) {
          if (result == null) return;
          updateOriginalSchedules(tappedSchedule!);
          if (result['choosedRest'] != null) {
            // 休息排班
            Rest choosedRest = result['choosedRest'] as Rest;
            if (choosedRest.restID == 'CLEAR') {
              tappedSchedule!.restID = "";
              tappedSchedule!.restName = "";
              tappedSchedule!.bgColor = Colors.transparent;
            } else {
              tappedSchedule!.restID = choosedRest.restID;
              tappedSchedule!.restName = choosedRest.restName;
            }
            tappedSchedule!.areaID = "";
            tappedSchedule!.areaName = "";
            tappedSchedule!.timeID = "";
            tappedSchedule!.timeName = "";
          } else {
            // 正常排班
            Area choosedArea = result['choosedArea'] as Area;
            Time choosedTime = result['choosedTime'] as Time;
            tappedSchedule!.restID = "";
            tappedSchedule!.restName = "";
            tappedSchedule!.areaID = choosedArea.areaID;
            tappedSchedule!.areaName = choosedArea.areaName;
            tappedSchedule!.timeID = choosedTime.timeID;
            tappedSchedule!.timeName = choosedTime.timeName;
          }
          // tappedSchedule!.isTapped = true;
          updateChangedSchedules(tappedSchedule!);
          updateBodyCell(
            tappedSchedule!.rowIndex,
            tappedSchedule!.columnIndex,
            tappedSchedule!,
          );
        });
      }
    } catch (e) {
      tappedSchedule = null;
      openWarnDialog(context, e.toString());
    }
    setState(() {
      tappedSchedule = tappedSchedule;
      isRightMouseClickInTableCell = false;
    });
  }

  // 右击
  void bodyCellOnSecondaryTap(cell, left, top, width, height, scrollLeft, scrollTop, totalScrollWidth, totalScrollHeight) {
    try {
      tappedSchedule = cell.data as Schedule;
      // tappedSchedule!.isTapped = true;
      // updateBodyCell(tappedSchedule!.rowIndex, tappedSchedule!.columnIndex,
      //     tappedSchedule!);
      // print(tappedSchedule);
    } catch (e) {
      tappedSchedule = null;
    }
    // double maxTableWidth = tableKey.currentContext?.size?.width ?? 0;
    // double maxTableHeight = tableKey.currentContext?.size?.height ?? 0;
    double maxTableWidth = totalScrollWidth;
    double maxTableHeight = totalScrollHeight;
    // 100: rightMenu height
    maxTableHeight = maxTableHeight - 100;
    setState(() {
      tappedSchedule = tappedSchedule;
      isRightMouseClickInTableCell = true;
      hoverRightMenuItemIndex = -1;
      rightClickLeftInTable = fixedColumnWidth1 + fixedColumnWidth2 + fixedColumnWidth3 + left + width - scrollLeft;
      rightClickTopInTable = top - scrollTop;
      if (rightClickLeftInTable >= maxTableWidth) {
        // 100: rightMenu width
        rightClickLeftInTable -= width + 100;
      }
      if (rightClickTopInTable >= maxTableHeight) {
        rightClickTopInTable = maxTableHeight;
      }
    });
  }

  void updateBodyCell(int rowIndex, int columnIndex, Schedule schedule) {
    if ((preTappedRowIndex != rowIndex || preTappedColumnIndex != columnIndex) && (preTappedRowIndex != -1 && preTappedColumnIndex != -1)) {
      this.bodyCellSchedules[preTappedRowIndex][preTappedColumnIndex]?.isTapped = false;
      this.bodyCellWidgets[preTappedRowIndex][preTappedColumnIndex] = getBodyCellWidget(preTappedRowIndex, preTappedColumnIndex, this.bodyCellSchedules[preTappedRowIndex][preTappedColumnIndex]!);
    }
    this.bodyCellSchedules[rowIndex][columnIndex] = schedule;
    this.bodyCellWidgets[rowIndex][columnIndex] = getBodyCellWidget(rowIndex, columnIndex, schedule);

    if (schedule.isTapped || (preTappedRowIndex == rowIndex && preTappedColumnIndex == columnIndex)) {
      preTappedRowIndex = rowIndex;
      preTappedColumnIndex = columnIndex;
    } else {
      preTappedRowIndex = -1;
      preTappedColumnIndex = -1;
    }

    table.updateBody(this.bodyCellWidgets);
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

  int findHeaderIndexByDate(DateTime date) {
    try {
      Schedule founded = headerCellSchedules.firstWhere((element) => element.year == date.year && element.month == date.month && element.day == date.day);
      return headerCellSchedules.indexOf(founded);
    } catch (e) {
      // not found
      return -1;
    }
  }

  // 单元格计算
  int getBodyDeferIndexBySchedule(Schedule schedule) {
    int deferIndex = 2; // 2 or 3 in man tab
    for (var i = 0; i < bodyCellSchedules.length; i++) {
      List<Schedule?> rowCellSchedules = bodyCellSchedules[i];
      if (rowCellSchedules.where((element) => element == schedule).toList().length >= 1) {
        deferIndex = rowCellSchedules.where((element) => element == null).toList().length;
        break;
      }
    }
    return deferIndex;
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

  void expandNewOneWeekHeaderCellSchedules(DateTime addedTime, [bool? isAdded]) {
    int currentWeekday = addedTime.weekday;
    for (int i = 0; i < currentWeekday; i++) {
      DateTime time = addedTime.add(Duration(days: -1 * i));
      Schedule schedule = generateHeaderScheduleFromDate(time);
      schedule.isAdded = isAdded == null ? true : isAdded;
      insertIfNotExistHeaderCellSchedules(schedule);
    }
    for (int i = 1; i <= 7 - currentWeekday; i++) {
      DateTime time = addedTime.add(Duration(days: i));
      Schedule schedule = generateHeaderScheduleFromDate(time);
      schedule.isAdded = isAdded == null ? true : isAdded;
      insertIfNotExistHeaderCellSchedules(schedule);
    }
  }

  // 按原有数据新增一周排班
  void expandOldOneWeekSchedules() {
    int needAddDays = 7;

    // header
    int preHeaderCellScheduleIndex = headerCellSchedules.length;
    Schedule lastHeaderSchedule = headerCellSchedules.last;
    DateTime lastTime = DateTime(lastHeaderSchedule.year, lastHeaderSchedule.month, lastHeaderSchedule.day);
    lastTime = lastTime.add(Duration(days: 1));
    if (isOutOfDateCheck(DateTime.now(), lastTime)) {
      // 最后的时间在当前时间之前
      expandNewOneWeekHeaderCellSchedules(DateTime.now().add(Duration(days: needAddDays)));
    } else {
      expandNewOneWeekHeaderCellSchedules(lastTime);
    }

    for (int day = 0; day < needAddDays; day++) {
      // body schedules
      for (int rowIndex = 0; rowIndex < bodyCellSchedules.length; rowIndex++) {
        int columnIndex = bodyCellWidgets[rowIndex].length;
        Schedule preBodyCellSchedule = bodyCellSchedules[rowIndex][columnIndex - needAddDays + day] as Schedule;
        Schedule headerSchedule = headerCellSchedules[preHeaderCellScheduleIndex + day];
        // 新增的记录是空白排班
        updateOriginalSchedules(new Schedule(
          year: headerSchedule.year,
          month: headerSchedule.month,
          day: headerSchedule.day,
          weekday: headerSchedule.weekday,
          userID: preBodyCellSchedule.userID,
          userName: preBodyCellSchedule.userName,
          gridID: "",
          gridName: "",
          areaName: "",
          areaID: "",
          timeID: "",
          timeName: "",
          restID: "",
          restName: "",
          rowIndex: rowIndex,
          columnIndex: columnIndex + day,
          isAdded: true,
        ));
        Schedule bodyCellSchedule = new Schedule(
          year: headerSchedule.year,
          month: headerSchedule.month,
          day: headerSchedule.day,
          weekday: headerSchedule.weekday,
          userID: preBodyCellSchedule.userID,
          userName: preBodyCellSchedule.userName,
          gridID: preBodyCellSchedule.gridID,
          gridName: preBodyCellSchedule.gridName,
          areaID: preBodyCellSchedule.areaID,
          areaName: preBodyCellSchedule.areaName,
          timeID: preBodyCellSchedule.timeID,
          timeName: preBodyCellSchedule.timeName,
          restID: preBodyCellSchedule.restID,
          restName: preBodyCellSchedule.restName,
          rowIndex: rowIndex,
          columnIndex: columnIndex + day,
          isAdded: true,
        );
        if (preBodyCellSchedule.timeID != "") {
          try {
            Time foundedTime = findTime(preBodyCellSchedule.timeID);
            if (foundedTime.isDisabled) {
              bodyCellSchedule.areaID = "";
              bodyCellSchedule.areaName = "";
              bodyCellSchedule.timeID = "";
              bodyCellSchedule.timeName = "";
              bodyCellSchedule.restID = "";
              bodyCellSchedule.restName = "";
            }
          } catch (e) {}
        }
        updateChangedSchedules(bodyCellSchedule);
        bodyCellSchedules[rowIndex].add(bodyCellSchedule);
      }
    }
  }

  void flushTableWithNewOneWeek() {
    // UNDO :「新增一周排班」时正确显示节假日
    expandNewOneWeekHeaderCellSchedules(DateTime.now());
    setState(() {
      table = createTable(getHeaderCellWidgetsFromSchedules(), resetBodyCellWidgetsFromHeader());
      table.scrollToTheFarRight();
      isTableBodyDataLoading = false;
    });
  }

  void flushTableWithOldOneWeek() {
    // UNDO :「新增一周排班」时正确显示节假日
    expandOldOneWeekSchedules();
    setState(() {
      table = createTable(getHeaderCellWidgetsFromSchedules(), updateBodyCellWidgetsFromSchedules());
      table.scrollToTheFarRight();
      isTableBodyDataLoading = false;
    });
  }

  Widget cellWidget(Widget child, [EdgeInsetsGeometry? padding]) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      child: child,
    );
  }

  // 单元格，请设置fontFamily,否则中文高度显示不正确
  Widget textColorWidget(String text, [Color? color]) {
    return Text(
      text,
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
        child: cellWidget(textColorWidget('姓名')),
      ),
      FreedomTableHeaderCell(
        fixedWidth: fixedColumnWidth3,
        isFixedColumn: true,
        child: cellWidget(textColorWidget('调休剩余')),
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
      grid.users.forEach((user) {
        rowIndex++;

        bodyCellWidgets.add([]);
        bodyCellSchedules.add([]);

        // 合并单元格计算
        int deferIndex = grid.users.indexOf(user) == 0 ? 3 : 2;

        // 网格名称
        if (deferIndex == 3) {
          bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
            rowspan: grid.users.length,
            child: cellWidget(textColorWidget(grid.gridName.toString())),
          ));
          bodyCellSchedules[rowIndex].add(null);
        }
        // 姓名
        bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
          child: cellWidget(textColorWidget(user.userName.toString())),
        ));
        bodyCellSchedules[rowIndex].add(null);
        // 调休剩余
        bodyCellWidgets[rowIndex].add(FreedomTableBodyCell(
          child: cellWidget(textColorWidget(user.restLeftDays.toString())),
        ));
        bodyCellSchedules[rowIndex].add(null);
        // 日期
        scheduleDatas.forEach((schedule) {
          if (schedule.userID == user.userID) {
            try {
              Schedule findedHeaderSchedule = findHeaderScheduleByDate(schedule.year, schedule.month, schedule.day);
              int columnIndex = headerCellSchedules.indexOf(findedHeaderSchedule) + deferIndex;
              // 填充可能的未返回的间断的空数据
              int preLength = bodyCellWidgets[rowIndex].length;
              if (preLength < columnIndex + 1) {
                for (int i = preLength; i < columnIndex + 1; i++) {
                  if (i >= deferIndex) {
                    Schedule nullSchedule = getBodyNullSchedule(rowIndex, i, this.headerCellSchedules[i - deferIndex], user);
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
            Schedule nullSchedule = getBodyNullSchedule(rowIndex, i, headerSchedule, user);
            // nullSchedule.isAdded = headerSchedule.isAdded;
            bodyCellWidgets[rowIndex].add(getBodyCellWidget(rowIndex, i, nullSchedule));
            bodyCellSchedules[rowIndex].add(nullSchedule);
          }
        }
      });
    });

    return bodyCellWidgets;
  }

  List<List<FreedomTableBodyCell>> updateBodyCellWidgetsFromSchedules() {
    List<List<FreedomTableBodyCell>> newBodyCellWidgets = [];

    int rowIndex = -1;
    bodyCellSchedules.forEach((rowCellSchedules) {
      rowIndex++;
      newBodyCellWidgets.add([]);
      // 合并单元格计算
      // int deferIndex =
      //     rowCellSchedules.where((element) => element == null).toList().length;
      int columnIndex = -1;
      rowCellSchedules.forEach((schedule) {
        columnIndex++;
        if (schedule == null) {
          // 网格名称 姓名 调休剩余
          newBodyCellWidgets[rowIndex].add(bodyCellWidgets[rowIndex][columnIndex]);
        } else {
          // 日期
          newBodyCellWidgets[rowIndex].add(getBodyCellWidget(rowIndex, columnIndex, schedule));
        }
      });
    });

    bodyCellWidgets = newBodyCellWidgets;

    return newBodyCellWidgets;
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
        textColorWidget(schedule.areaName, schedule.fontColor),
        SizedBox(
          height: 6,
        ),
        textColorWidget(schedule.timeName, schedule.fontColor),
      ];
    } else if (schedule.isManNull) {
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
            // MouseRegion(
            //   cursor: SystemMouseCursors.click,
            //   onEnter: (e) {
            //     schedule.isTapped = true;
            //     WidgetsBinding.instance.addPostFrameCallback((_) {
            //       updateBodyCell(rowIndex, columnIndex, schedule);
            //     });
            //   },
            //   onExit: (e) {
            //     schedule.isTapped = false;
            //     WidgetsBinding.instance.addPostFrameCallback((_) {
            //       updateBodyCell(rowIndex, columnIndex, schedule);
            //     });
            //   },
            //   child:
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
            // ),
            if ((isScheduleJustEdited(schedule) || schedule.isAdded) && !schedule.isOutOfDate)
              Positioned(
                top: 0,
                right: 0,
                child: CustomPaint(
                  painter: TrianglePainter(),
                  size: Size(10, 10),
                ),
              )
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
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  button("新增一周排班", () {
                    if (bodyCellSchedules.isEmpty || headerCellSchedules.isEmpty) {
                      flushTableWithNewOneWeek();
                      return;
                    }
                    setState(() {
                      isTableBodyDataLoading = true;
                    });
                    flushTableWithOldOneWeek();
                  }),
                ],
              ),
            ),
            //
            if (!canResave()) warningInfoWidget("每周X系统自动发布排班表"),
            if (canResave())
              Row(
                children: [
                  button("恢复", () {
                    setState(() {
                      isTableBodyDataLoading = true;
                    });
                    // 恢复新增的
                    headerCellSchedules = headerCellSchedules.where((schedule) => !schedule.isAdded).toList();
                    int rowIndex = -1;
                    bodyCellSchedules.forEach((rowCellSchedules) {
                      rowIndex++;
                      rowCellSchedules = rowCellSchedules.where((schedule) => schedule == null || !schedule.isAdded).toList();
                      // 恢复修改的
                      int columnIndex = -1;
                      rowCellSchedules.forEach((schedule) {
                        columnIndex++;
                        if (schedule != null && isScheduleJustEdited(schedule)) {
                          int beforeEditedIndex = getIndexInSchedules(originalSchedules, schedule);
                          if (beforeEditedIndex != -1) {
                            rowCellSchedules[columnIndex] = originalSchedules[beforeEditedIndex];
                          }
                        }
                      });
                      bodyCellSchedules[rowIndex] = rowCellSchedules;
                    });

                    setState(() {
                      table = createTable(getHeaderCellWidgetsFromSchedules(), updateBodyCellWidgetsFromSchedules());
                      table.scrollToTheFarRight();
                      originalSchedules.clear();
                      changedSchedules.clear();
                    });
                  }),
                  SizedBox(
                    width: 20,
                  ),
                  button("保存", () {
                    print(changedSchedules);
                  }, "primary"),
                ],
              )
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
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
                  if (event is PointerScrollEvent) {
                    setState(() {
                      isRightMouseClickInTableCell = false;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  // key: tableKey,
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
              if (isRightMouseClickInTableCell)
                Positioned(
                  left: rightClickLeftInTable,
                  top: rightClickTopInTable,
                  child: rightMenu(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rightMenu() {
    List rightMenuData = [
      {
        "name": '复制',
        "onTap": () {
          // tappedSchedule!.isTapped = false;
          // updateBodyCell(tappedSchedule!.rowIndex, tappedSchedule!.columnIndex,
          //     tappedSchedule!);
          if (tappedSchedule!.timeID != "") {
            Time foundTime = findTime(tappedSchedule!.timeID);
            if (foundTime.isDisabled) {
              setState(() {
                isRightMouseClickInTableCell = false;
              });
              return openWarnDialog(context, "「${foundTime.timeName}」班次已被禁用！无法复制！");
            }
          }
          setState(() {
            isRightMouseClickInTableCell = false;
            tappedScheduleSource = tappedSchedule;
          });
        }
      },
      {
        "name": '粘贴',
        "onTap": () {
          setState(() {
            isRightMouseClickInTableCell = false;
          });
          if (tappedScheduleSource == null) {
            return openWarnDialog(context, "请先选择复制内容！");
          }

          try {
            if (tappedSchedule!.isOutOfDate) {
              return openWarnDialog(context, "今天之前的排班无法粘贴！");
            }

            int newRowIndex = tappedSchedule!.rowIndex;
            int newColumnIndex = tappedSchedule!.columnIndex;
            if (newRowIndex != -1 && newColumnIndex != -1) {
              Schedule updatedSchedule = this.bodyCellSchedules[newRowIndex][newColumnIndex] as Schedule;
              // print(updatedSchedule);
              if (updatedSchedule.isOutOfDate) {
                return;
              }
              updateOriginalSchedules(updatedSchedule);
              updatedSchedule.gridID = tappedScheduleSource!.gridID;
              updatedSchedule.gridName = tappedScheduleSource!.gridName;
              updatedSchedule.areaID = tappedScheduleSource!.areaID;
              updatedSchedule.areaName = tappedScheduleSource!.areaName;
              updatedSchedule.timeID = tappedScheduleSource!.timeID;
              updatedSchedule.timeName = tappedScheduleSource!.timeName;
              updatedSchedule.restID = tappedScheduleSource!.restID;
              updatedSchedule.restName = tappedScheduleSource!.restName;
              updatedSchedule.bgColor = tappedScheduleSource!.bgColor;
              // updatedSchedule.isTapped = false;
              updateChangedSchedules(updatedSchedule);
              updateBodyCell(
                updatedSchedule.rowIndex,
                updatedSchedule.columnIndex,
                updatedSchedule,
              );
            }
          } catch (e) {}
        }
      }
    ];
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(230, 230, 230, 1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              offset: Offset(1, 0),
              spreadRadius: 1.0,
              blurRadius: 5.0,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rightMenuData.map((data) {
          int index = rightMenuData.indexOf(data);
          // if (data['name'] == '粘贴' && ((tappedSchedule != null && tappedSchedule!.isOutOfDate) || (tappedScheduleSource == null))) {
          //   return Container();
          // }
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                hoverRightMenuItemIndex = index;
              });
            },
            onExit: (event) {
              setState(() {
                hoverRightMenuItemIndex = -1;
              });
            },
            child: GestureDetector(
              onTap: data['onTap'],
              child: Container(
                decoration: BoxDecoration(
                  color: hoverRightMenuItemIndex == index ? Color.fromRGBO(235, 240, 255, 1) : Color.fromRGBO(242, 242, 242, 1),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 10,
                ),
                margin: EdgeInsets.only(top: index == 0 ? 0 : 5),
                child: Text(
                  data['name'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(51, 51, 51, 1),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget warningInfoWidget(String message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 240, 240, 1),
        border: Border.all(
          color: Color.fromRGBO(250, 200, 200, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              // height: 2,
              fontFamily: "YaHei",
              color: Color.fromRGBO(250, 80, 60, 1),
            ),
          ),
        ],
      ),
    );
  }
}
