import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'base_page.dart';
import 'schedule_common.dart';
import 'package:freedom_table/freedom_table.dart';
import 'schedule_tab_man.dart';
import 'schedule_tab_job.dart';
import 'schedule_order.dart';

class ScheduleManage extends StatefulWidget {
  const ScheduleManage({super.key});

  @override
  State<ScheduleManage> createState() => _ScheduleManageState();
}

class _ScheduleManageState extends State<ScheduleManage> with SingleTickerProviderStateMixin {
  late TabController tabControl;

  List<String> tabNames = [
    "按人员",
    "按岗位",
  ];
  List<Widget> tabWidgets = [];

  @override
  void initState() {
    super.initState();
    tabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabs(),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  child: ManTab(),
                  visible: tabControl.index == 0,
                ),
                Visibility(
                  child: JobTab(),
                  visible: tabControl.index == 1,
                ),
              ],
            ),
          ),
        ],
      ),
      bcontext: context,
    );
  }

  tabs() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: CusTheme.theme),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(children: [
        Container(
          width: 300,
          child: DefaultTabController(
            length: 2,
            child: TabBar(
              onTap: (idx) {
                setState(() {
                  tabControl.index = idx;
                });
              },
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              unselectedLabelColor: CusTheme.color6,
              labelColor: Colors.white,
              labelStyle: CusTheme.styleF14CfBold,
              indicatorColor: CusTheme.blue,
              indicatorWeight: 0.01,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: tabNames.map((element) => tabWidget(tabNames.indexOf(element), element)).toList(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget tabWidget(int index, String title) {
    Color borderColor = tabControl.index == index ? CusTheme.theme : CusTheme.themeLight;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(
            horizontal: 0,
          ),
          margin: EdgeInsets.fromLTRB(index == 0 ? 0 : 2, 0, 0, 0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tabControl.index == index ? CusTheme.theme : CusTheme.bluelight,
            border: Border(
              left: BorderSide(width: 1, color: borderColor),
              right: BorderSide(width: 1, color: borderColor),
              top: BorderSide(width: 1, color: borderColor),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            // style: tabControl.index == index ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
}
