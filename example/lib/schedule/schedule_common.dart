import 'package:flutter/material.dart';

/// 界面需求：
/// 1. 「排班管理」-「按人员」表格中，某人的所有排班数据，包括不属于其「主从属网格」中「其他网格 > 岗位」的排班数据，都需合并显示在其「主从属网格」中。
/// 2. 「白班」「夜班」是不用在界面中添加的，后台自动判断某个岗位是属于「白班」还是「夜班」
/// 3. 「禁用」某班次后，
///   1. 「修改排班数据」时，不显示该排班，也就不能选择该排班
///   2. 「复制」或「新增一周排班」时，涉及到被禁用班次的排班数据时，粘贴结果为空
///   3. 其余情况都维持现状

// 班次数据
List times = [
  {'timeID': 'A班', 'timeName': 'A班', 'isDisabled': true, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'B班', 'timeName': 'B班B班B班B班B班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'C班', 'timeName': 'C班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'D班', 'timeName': 'D班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'E班', 'timeName': 'E班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'F班', 'timeName': 'F班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'G班', 'timeName': 'G班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'H班', 'timeName': 'H班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'I班', 'timeName': 'I班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'J班', 'timeName': 'J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班J班', 'isDisabled': false, 'canDelete': false, 'isDeleted': false, 'timeStart': '08:30', 'timeEnd': '17:30'},
  {'timeID': 'K班', 'timeName': 'K班', 'isDisabled': false, 'canDelete': false, 'isDeleted': true, 'timeStart': '08:30', 'timeEnd': '17:30'},
];

// 休息理由数据
/// 界面中有个『 动词 ：「清空」』与下列名词数据排在一起，建议后端不要将其存入数据库中，前端会特殊处理
/// 所以：数据库中restID请不要起名为『CLEAR』，在前端已被『清空』占用
List rests = [
  {"restID": '年假', 'restName': '年假'},
  {"restID": '休息', 'restName': '休息'},
  {"restID": '病假', 'restName': '病假'},
  {"restID": '丧假', 'restName': '丧假'},
  {"restID": '婚假', 'restName': '婚假'},
  {"restID": '陪产假', 'restName': '陪产假'},
  {"restID": '育儿假', 'restName': '育儿假'},
];

// 「网格」数据， 包括「网格内岗位」+ 「岗位内人员」
List grids = [
  {
    'gridID': '姑苏区1',
    'gridName': '姑苏区1',
    'areas': [
      {
        'areaID': '苏E-GS-01',
        'areaName': '苏E-GS-01苏E-GS-01',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-02',
        'areaName': '苏E-GS-02',
        'areaWorkTimeDescription': '夜班',
      },
      {
        'areaID': '苏E-GS-03',
        'areaName': '苏E-GS-03',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-04',
        'areaName': '苏E-GS-04',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-05',
        'areaName': '苏E-GS-05',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-06',
        'areaName': '苏E-GS-06',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-07',
        'areaName': '苏E-GS-07',
        'areaWorkTimeDescription': '白班',
      },
    ],
    'users': [
      {
        'userID': '张三三',
        'userName': '张三三张三三',
        'restLeftDays': -5,
      },
      {
        'userID': '李四四',
        'userName': '李四四',
        'restLeftDays': 21,
      },
      {
        'userID': '王五五',
        'userName': '王五五',
        'restLeftDays': 13,
      },
    ],
  },
  {
    'gridID': '姑苏区2',
    'gridName': '姑苏区2姑苏区2姑苏区2姑苏区2',
    'areas': [
      {
        'areaID': '苏E-GS-21',
        'areaName': '苏E-GS-21',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-22',
        'areaName': '苏E-GS-22',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-23',
        'areaName': '苏E-GS-23',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-24',
        'areaName': '苏E-GS-24',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-25',
        'areaName': '苏E-GS-25',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-26',
        'areaName': '苏E-GS-26',
        "areaWorkTimeDescription": "白班",
      },
      {
        'areaID': '苏E-GS-27',
        'areaName': '苏E-GS-27',
        'areaWorkTimeDescription': '白班',
      },
    ],
    'users': [
      {
        'userID': '张三2',
        'userName': '张三2',
        'restLeftDays': -5,
      },
      {
        'userID': '李四2',
        'userName': '李四2',
        'restLeftDays': 21,
      },
      {
        'userID': '王五2',
        'userName': '王五2',
        'restLeftDays': 13,
      },
    ],
  },
  {
    'gridID': '姑苏区3',
    'gridName': '姑苏区3姑苏区3姑苏区3姑苏区3',
    'areas': [
      {
        'areaID': '苏E-GS-31',
        'areaName': '苏E-GS-31',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-32',
        'areaName': '苏E-GS-32',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-33',
        'areaName': '苏E-GS-33',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-34',
        'areaName': '苏E-GS-34',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-35',
        'areaName': '苏E-GS-35',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-36',
        'areaName': '苏E-GS-36',
        'areaWorkTimeDescription': '白班',
      },
      {
        'areaID': '苏E-GS-37',
        'areaName': '苏E-GS-37',
        'areaWorkTimeDescription': '白班',
      },
    ],
    'users': [
      {
        'userID': '张三3',
        'userName': '张三3',
        'restLeftDays': -5,
      },
      {
        'userID': '李四3',
        'userName': '李四3',
        'restLeftDays': 21,
      },
      {
        'userID': '王五3',
        'userName': '王五3',
        'restLeftDays': 13,
      },
    ],
  },
];

// 按人员排班数据
List scheduleDataGroupByUserFromAPIOriginal = [
  // // {
  // //   'year': 2023,
  // //   'month': 4,
  // //   'day': 1,
  // //   'weekday': '日',
  // //   'userID': '王五五',
  // // },
  // {
  //   'year': 2023,
  //   'month': 4,
  //   'day': 2,
  //   'weekday': '虚拟节日',
  //   'userID': '张三三',
  //   'restID': '休息',
  // },
  // {
  //   'year': 2023,
  //   'month': 4,
  //   'day': 14,
  //   'weekday': '日',
  //   'userID': '李四四',
  //   'areaID': '苏E-GS-22',
  //   'timeID': 'B班',
  // },
  // {
  //   'year': 2023,
  //   'month': 4,
  //   'day': 8,
  //   'weekday': '虚拟节日',
  //   'userID': '王五2',
  //   'areaID': '苏E-GS-01',
  //   'timeID': 'A班',
  // },
  {
    'year': 2023,
    'month': 5,
    'day': 15,
    'weekday': '日',
    'userID': '张三三',
    'areaID': '苏E-GS-22',
    'timeID': 'A班',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 16,
    'weekday': '特殊节日',
    'userID': '张三三',
    'areaID': '苏E-GS-32',
    'timeID': 'D班',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 17,
    'weekday': '一',
    'userID': '张三2',
    'restID': '休息',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 17,
    'weekday': '一',
    'userID': '李四四',
    'areaID': '苏E-GS-01',
    'timeID': 'H班',
  },
];

// 按岗位排班数据
List scheduleDataGroupByAreaFromAPIOriginal = [
  {
    'year': 2023,
    'month': 2,
    'day': 1,
    'weekday': '六',
    'areaID': '苏E-GS-01',
    'userID': '张三三',
    'timeID': 'A班',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 1,
    'weekday': '日',
    'userID': '张三三',
    'areaID': '苏E-GS-01',
    'timeID': 'B班',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 20,
    'weekday': '日',
    'userID': '王五五',
    'areaID': '苏E-GS-01',
    'timeID': 'H班',
  },
  {
    'year': 2023,
    'month': 5,
    'day': 21,
    'weekday': '日',
    'userID': '王五五',
    'areaID': '苏E-GS-02',
    'timeID': 'H班',
  },
];

openDialog(BuildContext context, Widget child) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => Dialog(
      child: child,
    ),
  );
}

openWarnDialog(BuildContext context, String msg) {
  openDialog(
    context,
    ScheduleWarningDialog(
      title: "警告",
      content: msg,
    ),
  );
}

Widget button(String title, void Function()? onPressed, [String? type]) {
  List<Color> bgColor = [Colors.white, Colors.white];
  Color fontColor = Color.fromRGBO(80, 120, 240, 1);
  List<Widget> children = [
    Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: fontColor,
      ),
    )
  ];
  switch (type) {
    case 'primary':
      bgColor = [
        Color.fromRGBO(100, 160, 250, 1),
        Color.fromRGBO(80, 120, 240, 1),
      ];
      fontColor = Colors.white;
      children = [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: fontColor,
          ),
        )
      ];
      break;
    case 'publish':
      fontColor = Color.fromRGBO(250, 140, 0, 1);
      children = [
        Icon(
          Icons.near_me,
          size: 16,
          color: fontColor,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: fontColor,
          ),
        )
      ];
      break;
  }
  return Container(
    decoration: BoxDecoration(
      // border: Border.all(color: fontColor, width: 1),
      borderRadius: BorderRadius.circular(2),
      gradient: LinearGradient(
        colors: bgColor,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
      style: ButtonStyle(
        // side: MaterialStateProperty.resolveWith(
        //     (states) => BorderSide(width: 1.0, color: fontColor)),
        // shape: MaterialStateProperty.resolveWith((states) =>
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0))),
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(horizontal: 10)),
        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        shadowColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        fixedSize: MaterialStateProperty.resolveWith((states) => Size.fromHeight(32)),
      ),
      onPressed: onPressed,
    ),
  );
}

Widget textFormField(controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      isCollapsed: true,
      hintText: '请输入',
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(204, 204, 204, 1)),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
    ),
    style: TextStyle(
      fontSize: 14,
    ),
  );
}

Widget timeTextFormField(context, controller, [String? hintText]) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 32),
    child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isCollapsed: true,
          suffixIcon: Icon(Icons.schedule, size: 16),
          hintText: hintText ?? '请选择',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(204, 204, 204, 1)),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        ),
        style: TextStyle(
          fontSize: 14,
        ),
        onTap: () async {
          final timePicked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.inputOnly,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                child: child ?? const SizedBox(),
              );
            },
          );
          if (timePicked != null) {
            var hour = timePicked.hour.toString().padLeft(2, '0');
            var minute = timePicked.minute.toString().padLeft(2, '0');
            controller.text = '$hour:$minute';
          }
        }),
  );
}

Widget dayTextFormField(context, controller, [DateTime? initialDate, String? hintText]) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 32),
    child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isCollapsed: true,
          suffixIcon: Icon(Icons.calendar_month, size: 16),
          hintText: hintText ?? '请选择',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(204, 204, 204, 1)),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        ),
        style: TextStyle(
          fontSize: 14,
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 100, 1),
            lastDate: DateTime(DateTime.now().year + 100, 1),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.day,
            helpText: '选择日期',
            cancelText: '取消',
            confirmText: '确定',
          );
          if (picked != null) controller.text = yearMonthDayFormat(picked);
        }),
  );
}

Widget radio<T>(T value, T? groupValue, String title, bool Function() isEqual, void Function(T?)? onChanged, [bool isToggleable = true]) {
  return InkWell(
    key: GlobalObjectKey(value as Object),
    onTap: onChanged != null && isToggleable ? () => onChanged(value) : () {},
    child: Container(
      margin: EdgeInsets.only(right: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 80),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
                value: value,
                groupValue: groupValue,
                onChanged: isToggleable ? onChanged : (value) {},
                toggleable: isToggleable,
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (!isToggleable) {
                    return Color.fromRGBO(51, 51, 51, 0.3);
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Color.fromRGBO(80, 120, 240, 1);
                  }
                  return Color.fromRGBO(204, 204, 204, 1);
                })),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: !isToggleable
                      ? Color.fromRGBO(51, 51, 51, 0.3)
                      : isEqual()
                          ? Color.fromRGBO(250, 140, 0, 1)
                          : Color.fromRGBO(51, 51, 51, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String yearMonthFormat(DateTime date) {
  var year = date.year.toString().padLeft(4, '0');
  var month = date.month.toString().padLeft(2, '0');
  return '$year-$month';
}

String yearMonthDayFormat(DateTime date) {
  var year = date.year.toString().padLeft(4, '0');
  var month = date.month.toString().padLeft(2, '0');
  var day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

bool isRedWeekday(String weekday) {
  return ["一", "二", "三", "四", "五"].firstWhere((element) => element == weekday, orElse: () => "") == "";
}

bool isWeekday(String weekday) {
  return ["一", "二", "三", "四", "五", "六", "日"].firstWhere((element) => element == weekday, orElse: () => "") != "";
}

bool isOutOfDateCheck(DateTime basetime, DateTime checkedTime) {
  basetime = DateTime(basetime.year, basetime.month, basetime.day, 0, 0, 0);
  checkedTime = DateTime(checkedTime.year, checkedTime.month, checkedTime.day, 0, 0, 0);
  return basetime.microsecondsSinceEpoch > checkedTime.microsecondsSinceEpoch;
}

// UNDO :「新增一周排班」时正确显示节假日
String getWeekday(DateTime date) {
  int weekday = date.weekday;
  String weekdayString = "";
  switch (weekday) {
    case 1:
      weekdayString = "一";
      break;
    case 2:
      weekdayString = "二";
      break;
    case 3:
      weekdayString = "三";
      break;
    case 4:
      weekdayString = "四";
      break;
    case 5:
      weekdayString = "五";
      break;
    case 6:
      weekdayString = "六";
      break;
    case 7:
      weekdayString = "日";
      break;
  }
  return weekdayString;
}

String getFixedWeekDay(Schedule schedule) {
  if (!isWeekday(schedule.day.toString())) {
    return schedule.weekday;
  } else {
    return getWeekday(DateTime(schedule.year, schedule.month, schedule.day));
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Color.fromRGBO(250, 140, 0, 1);
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 休息理由
class Rest {
  String restID;
  String restName;
  Rest({
    required this.restID,
    required this.restName,
  });
  @override
  String toString() {
    return "Rest ( ID:$restID Name:$restName )";
  }
}

// 班次
class Time {
  String timeID;
  String timeName;
  String timeStart;
  String timeEnd;
  bool isDisabled;
  bool canDelete;
  bool isDeleted;
  Time({
    required this.timeID,
    required this.timeName,
    required this.timeStart,
    required this.timeEnd,
    this.isDisabled = false,
    this.canDelete = false,
    this.isDeleted = false,
  });
  @override
  String toString() {
    return "Time ( ID:$timeID Name:$timeName $timeStart-$timeEnd isDisabled:$isDisabled canDelete:$canDelete)";
  }
}

// 网格
class Grid {
  String gridID;
  String gridName;
  // 网格内岗位列表
  List<Area> areas;
  // 网格内人员列表，只包含主从属该网格的人员
  List<User> users;
  Grid({
    required this.gridID,
    required this.gridName,
    this.areas = const [],
    this.users = const [],
  });
  @override
  String toString() {
    return "Grid ( ID:$gridID Name:$gridName areas:$areas users:$users )";
  }
}

// 人员
class User {
  String gridID;
  String gridName;
  String userID;
  String userName;
  int restLeftDays;
  User({
    required this.gridID,
    required this.gridName,
    required this.userID,
    required this.userName,
    required this.restLeftDays,
  });
  @override
  String toString() {
    return "User ( ID:$userID Name:$userName restLeftDays:$restLeftDays  )";
  }
}

// 岗位
class Area {
  String gridID;
  String gridName;
  String areaID;
  String areaName;
  String areaWorkTimeDescription;
  Area({
    required this.gridID,
    required this.gridName,
    required this.areaID,
    required this.areaName,
    this.areaWorkTimeDescription = '白班',
  });
  @override
  String toString() {
    return "Area ( ID :areaID Name:$areaName areaWorkTimeDescription:$areaWorkTimeDescription)";
  }
}

/// 排班
/// 「按人员」空白排班，即无工作排班又无休息排班 : year & month & day & weekday & userID 必填，其余空字符串
/// 「按岗位」空白排班，即无工作排班 : year & month & day & weekday & areaID 必填，其余空字符串
class Schedule {
  int year;
  int month;
  int day;
  String weekday;
  String userID;
  String userName;

  /// 注意：是该岗位从属的「网格」，不是人员的「主从属网格」，因为被告知：人可以去「其他机动网格」内工作
  String gridID;
  String gridName;
  String areaID;
  String areaName;
  String timeID;
  String timeName;
  String restID;
  String restName;
  bool isOutOfDate;

  /// 是否是新增一周排班新增的
  bool isAdded;
  int rowIndex;
  int columnIndex;
  bool isTapped;
  Color fontColor;
  Color bgColor;
  Schedule({
    required this.year,
    required this.month,
    required this.day,
    required this.weekday,
    required this.userID,
    required this.userName,
    required this.gridID,
    required this.gridName,
    required this.areaID,
    required this.areaName,
    required this.timeID,
    required this.timeName,
    required this.restID,
    required this.restName,
    this.isOutOfDate = false,
    this.isAdded = false,
    this.rowIndex = -1,
    this.columnIndex = -1,
    this.isTapped = false,
    this.fontColor = const Color.fromRGBO(51, 51, 51, 1),
    this.bgColor = Colors.transparent,
  }) {
    this.isOutOfDate = isOutOfDateCheck(
      DateTime.now(),
      DateTime(this.year, this.month, this.day),
    );
  }

  @override
  String toString() {
    return "Schedule ( $year-$month-$day-$weekday user:$userName area:$areaName time:$timeName rest:$restName)";
  }

  static copy(Schedule old) {
    return new Schedule(
      year: old.year,
      month: old.month,
      day: old.day,
      weekday: old.weekday,
      userID: old.userID,
      userName: old.userName,
      gridID: old.gridID,
      gridName: old.gridName,
      areaID: old.areaID,
      areaName: old.areaName,
      timeID: old.timeID,
      timeName: old.timeName,
      restID: old.restID,
      restName: old.restName,
      isOutOfDate: old.isOutOfDate,
      isAdded: false,
      rowIndex: old.rowIndex,
      columnIndex: old.columnIndex,
      isTapped: old.isTapped,
      fontColor: old.fontColor,
      bgColor: old.bgColor,
    );
  }

  bool isSame(Schedule old) {
    return this.areaID == old.areaID && this.timeID == old.timeID && this.restID == old.restID;
  }

  bool get isManNull {
    return this.areaID == '' && this.timeID == '' && this.restID == '';
  }

  bool get isJobNull {
    return this.userID == '' && this.timeID == '' && this.restID == '';
  }
}

class ScheduleDialog extends StatefulWidget {
  final String title;
  final double width;
  final Widget child;
  final void Function()? onCancelPressed;
  final void Function()? onConfirmPressed;
  final bool? isShowCancel;
  const ScheduleDialog({
    super.key,
    required this.title,
    required this.width,
    required this.child,
    this.onCancelPressed,
    this.onConfirmPressed,
    this.isShowCancel,
  });

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // top
          Container(
            height: 40,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(100, 160, 250, 1),
                Color.fromRGBO(80, 120, 240, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.clear,
                        color: Color.fromRGBO(235, 240, 255, 1),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // content
          Container(
            padding: EdgeInsets.all(20),
            child: widget.child,
          ),
          // bottom
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color.fromRGBO(230, 230, 230, 1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isShowCancel == null || widget.isShowCancel == true)
                  button('取消', () {
                    if (widget.onCancelPressed != null) widget.onCancelPressed!();
                    Navigator.pop(context);
                  }),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                ),
                button('确定', () {
                  if (widget.onConfirmPressed != null) widget.onConfirmPressed!();
                  Navigator.pop(context);
                }, 'primary'),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ScheduleWarningDialog extends StatefulWidget {
  final String title;
  final String content;
  final void Function()? onConfirmPressed;
  const ScheduleWarningDialog({
    super.key,
    required this.title,
    required this.content,
    this.onConfirmPressed,
  });

  @override
  State<ScheduleWarningDialog> createState() => _ScheduleWarningDialogState();
}

class _ScheduleWarningDialogState extends State<ScheduleWarningDialog> {
  @override
  Widget build(BuildContext context) {
    return ScheduleDialog(
      title: widget.title,
      width: 320,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              widget.content,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                fontFamily: 'YaHei',
              ),
            ),
          ),
        ],
      ),
      isShowCancel: false,
      onConfirmPressed: widget.onConfirmPressed,
    );
  }
}

class ScheduleConfirmDialog extends StatefulWidget {
  final String title;
  final String content;
  final void Function()? onCancelPressed;
  final void Function()? onConfirmPressed;
  const ScheduleConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.onCancelPressed,
    this.onConfirmPressed,
  });

  @override
  State<ScheduleConfirmDialog> createState() => _ScheduleConfirmDialogState();
}

class _ScheduleConfirmDialogState extends State<ScheduleConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return ScheduleDialog(
      title: widget.title,
      width: 320,
      child: Column(
        children: [
          Image.asset(
            'images/schedule_warning.png',
            width: 48,
            height: 48,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              widget.content,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                fontFamily: 'YaHei',
              ),
            ),
          ),
        ],
      ),
      onCancelPressed: widget.onCancelPressed,
      onConfirmPressed: widget.onConfirmPressed,
    );
  }
}
