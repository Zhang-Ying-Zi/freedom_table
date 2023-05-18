import 'package:flutter/material.dart';

/// 自定义主题颜色，样式等
class CusTheme {
  //主色
  static const Color theme = Color(0xFF2196F3);
  static const Color themeDark = Color(0xFF2196F3);
  static const Color themeDis = Color(0x662196F3);
  static const Color themeLight = Color(0xFF81C0FF);

  static const Color blue = Color(0xFF5078F0);
  static const Color red = Color(0xFFFA503C);
  static const Color green = Color(0xFF00BE5A);
  static const Color orange = Color(0xFFFA8C00);
  static const Color yellow = Color(0xFFFADC32);
  static const Color white = Color(0xFFFFFFFF);
  static const Color bluelight = Color(0xFFE4F1FE);
  static const Color blueDeep = Color(0xFF1D84D5);

  // 文本色
  static const Color color3 = Color(0xFF333333);
  static const Color color6 = Color(0xFF666666);
  static const Color color9 = Color(0xFF999999);
  static const Color colorC = Color(0xFFCCCCCC);
  static const Color colorE6 = Color(0xFFE6E6E6);

  // 辅助色
  static const Color colorEBEBF5 = Color(0xFFEBEBF5);
  static const Color colorF2 = Color(0xFFF2F2F2);
  static const Color colorF5 = Color(0xFFF5F5F5);
  static const Color colorF7 = Color(0xFFF7F7F7);
  static const Color colorEBF0FF = Color(0xFFEBF0FF);
  static const Color colorFFF5E6 = Color(0xFFFFF5E6); //橙色对应的按压色
  static const Color colorbg = Color(0xFFF2F2F2);

  /// 间隔
  static const Widget gapH5 = SizedBox(width: 5);
  static const Widget gapH10 = SizedBox(width: 10);
  static const Widget gapH20 = SizedBox(width: 20);

  static const Widget gapV5 = SizedBox(height: 5);
  static const Widget gapV10 = SizedBox(height: 10);
  static const Widget gapV20 = SizedBox(height: 20);

  ///主题
  static ThemeData mainTheme = ThemeData(
    fontFamily: 'YaHei',
    primaryColor: CusTheme.theme,
    //#5a82f0
    dividerColor: Color.fromRGBO(230, 230, 230, 1),
    // #e6e6e6
    textTheme: const TextTheme(
      bodyText2: TextStyle(
        fontSize: 14.0,
        fontFamily: 'YaHei',
        color: Color.fromRGBO(74, 74, 74, 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color.fromRGBO(74, 74, 74, 1),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: TextStyle(
      color: CusTheme.theme,
      fontSize: 14,
      fontFamily: 'YaHei',
    ))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: CusTheme.theme,
        side: BorderSide(
          color: CusTheme.theme,
          width: 1,
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );

  /// 样式
  /// fontsize 14 color
  static const styleF14Theme = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: theme);

  static const styleF14White = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: white);

  static const styleF16White = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 16, color: white);

  static const styleF14WhiteBold = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.bold, fontSize: 14, color: white);

  static const styleF14CC = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: colorC);

  /// fontsize 14 color #333333
  static const styleF14C3 = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: color3);

  /// fontsize 14 color #333333 bold
  static const styleF14C3Bold = TextStyle(
    fontFamily: 'YaHei',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: color3,
  );

  /// fontsize 14 color #999999
  static const styleF14C9 = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: color9);

  /// fontsize 14 color #cccccc
  static const styleF14Cc = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.normal, fontSize: 14, color: colorC);

  /// fontsize 14 color #666666
  static const styleF14C6 = TextStyle(fontFamily: 'YaHei', fontSize: 14, color: color6);

  /// fontsize 14 color #666666 bold
  static const styleF14C6Bold = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.bold, fontSize: 14, color: color6);

  /// fontsize 14 color white bold
  static const styleF14CfBold = TextStyle(fontFamily: 'YaHei', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white);

  /// fontsize 14 color white bold
  static const styleF14Cred = TextStyle(fontFamily: 'YaHei', fontSize: 14, color: red);

  /// fontsize 16 color #333333 bold
  static const styleF16C3Bold = TextStyle(
    fontFamily: 'YaHei',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: color3,
  );

  /// fontsize 24 color #333333 bold D-din
  static const styleF24C3BoldDin = TextStyle(fontFamily: 'D-DIN', fontWeight: FontWeight.w700, fontSize: 24, color: color3);

  /// 小组件
  static Widget vLinearItem = Container(
    width: 5,
    height: 15,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(2), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF64A0FA), Color(0xFF5078F0)])),
  );
}

/// 基础页面，带有标题栏的那种
class BasePage extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool? bottomSafe;
  final bool? resizeToAvoidBottomInset;
  final String? title;
  final BuildContext bcontext;
  final Widget body;
  final Widget? action;
  final Widget? endDrawer;
  final bool? hasBack;
  final int? currentIndex;
  final String? subTitle;

  const BasePage(
      {Key? key,
      this.action,
      required this.bcontext,
      required this.body,
      this.bottomNavigationBar,
      this.bottomSafe,
      this.appBar,
      this.endDrawer,
      this.resizeToAvoidBottomInset,
      this.currentIndex,
      this.subTitle,
      this.title,
      this.hasBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CusTheme.white,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: body,
              ),
            ),
          ],
        ),
        bottom: bottomSafe ?? true,
      ),
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
