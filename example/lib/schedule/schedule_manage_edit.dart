import 'package:flutter/material.dart';
import 'schedule_common.dart';

enum ScheduleType {
  RESTSCHEDULE,
  WORKSCHEDULE,
}

class ScheduleManageEdit extends StatefulWidget {
  final List<Rest> restDatas;
  final List<Grid> gridDatas;
  final List<Time> timeDatas;
  final Schedule schedule;
  final Rest? choosedRest;
  final Area? choosedArea;
  final Time? choosedTime;
  const ScheduleManageEdit({
    super.key,
    required this.restDatas,
    required this.gridDatas,
    required this.timeDatas,
    required this.schedule,
    this.choosedRest,
    this.choosedArea,
    this.choosedTime,
  });

  @override
  State<ScheduleManageEdit> createState() => _ScheduleManageEditState();
}

class _ScheduleManageEditState extends State<ScheduleManageEdit> {
  late ScheduleType scheduleType;
  Rest? choosedRest;
  Area? choosedArea;
  Time? choosedTime;

  @override
  void initState() {
    super.initState();
    if (widget.choosedRest == null && widget.choosedArea == null && widget.choosedTime == null) {
      scheduleType = ScheduleType.RESTSCHEDULE;
      choosedRest = widget.restDatas[0];
    } else {
      choosedRest = widget.choosedRest;
      choosedArea = widget.choosedArea;
      choosedTime = widget.choosedTime;
      if (choosedRest != null) {
        scheduleType = ScheduleType.RESTSCHEDULE;
      } else {
        scheduleType = ScheduleType.WORKSCHEDULE;
        Object key = choosedArea as Object;
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            if (GlobalObjectKey(key).currentContext != null) {
              Scrollable.ensureVisible(GlobalObjectKey(key).currentContext!);
            }
          },
        );
      }
      // print("${choosedArea}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void changeChoosedRest(Rest? value) {
    if (value != null) {
      setState(() {
        scheduleType = ScheduleType.RESTSCHEDULE;
        choosedRest = value;
        choosedArea = null;
        choosedTime = null;
        // print(choosedRest!.restID);
      });
    }
  }

  void changeChoosedArea(Area? value) {
    if (value != null) {
      setState(() {
        scheduleType = ScheduleType.WORKSCHEDULE;
        choosedArea = value;
        choosedRest = null;
        // print(choosedArea!.areaID);
      });
    }
  }

  void changeChoosedTime(Time? value) {
    if (value != null) {
      setState(() {
        scheduleType = ScheduleType.WORKSCHEDULE;
        choosedTime = value;
        choosedRest = null;
        // print(choosedTime!.timeID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
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
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '排班编辑',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "${yearMonthDayFormat(new DateTime(widget.schedule.year, widget.schedule.month, widget.schedule.day))}(${widget.schedule.weekday})  ${widget.schedule.userName}",
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                title('不排班'),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 245, 235, 1),
                  ),
                  child: Wrap(
                    children: widget.restDatas.map((rest) {
                      return radio<Rest>(
                        rest,
                        choosedRest,
                        rest.restName,
                        () => choosedRest != null ? rest.restID == choosedRest!.restID : false,
                        (Rest? value) => changeChoosedRest(value),
                      );
                    }).toList(),
                  ),
                ),
                title('排班'),
                Container(
                  constraints: BoxConstraints(maxHeight: 240),
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    // 网格
                    child: Column(
                      children: widget.gridDatas.map((grid) {
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(242, 242, 242, 1),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  grid.gridName,
                                  style: TextStyle(
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // 岗位
                              Container(
                                width: double.infinity,
                                // margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(5),
                                child: Wrap(
                                  children: grid.areas.map((area) {
                                    return radio<Area>(
                                      area,
                                      choosedArea,
                                      area.areaName,
                                      () => choosedArea != null ? area.areaID == choosedArea!.areaID : false,
                                      (Area? value) => changeChoosedArea(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // 班次
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 242, 242, 1),
                  ),
                  child: Wrap(
                    children: widget.timeDatas.map((time) {
                      return time.isDisabled
                          ? Container()
                          : radio<Time>(
                              time,
                              choosedTime,
                              time.timeName,
                              () => choosedTime != null ? time.timeID == choosedTime!.timeID : false,
                              (Time? value) => changeChoosedTime(value),
                              scheduleType == ScheduleType.WORKSCHEDULE,
                            );
                    }).toList(),
                  ),
                ),
              ],
            ),
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
                button('取消', () {
                  Navigator.pop(context);
                }),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                ),
                button('确定', () {
                  if (scheduleType == ScheduleType.RESTSCHEDULE && choosedRest == null) {
                    return openWarnDialog(context, "请选择休息理由！");
                  } else if (scheduleType == ScheduleType.WORKSCHEDULE && (choosedArea == null || choosedTime == null)) {
                    if (choosedArea == null) return openWarnDialog(context, "请选择岗位！");
                    if (choosedTime == null) return openWarnDialog(context, "请选择班次！");
                  } else {
                    Navigator.pop(context, {
                      "choosedRest": choosedRest,
                      "choosedArea": choosedArea,
                      "choosedTime": choosedTime,
                    });
                  }
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

  Widget title(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          color: Color.fromRGBO(51, 51, 51, 1),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
