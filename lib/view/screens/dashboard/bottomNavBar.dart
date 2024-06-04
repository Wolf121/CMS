import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/view/screens/dashboard/screens/complaint.dart';
import 'package:dha_resident_app/view/screens/dashboard/screens/dashboard.dart';
import 'package:dha_resident_app/view/screens/dashboard/screens/news.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:dha_resident_app/view/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../../../constant.dart';
import '../login/login.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = '/bottomNavBar';

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  String initialTabString = "Dashboard";
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[]; // Declare an empty list here
  MotionTabBarController? _motionTabBarController;

  bool isOpened = false;

  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    // You can also clear any other session-related data if needed
  }

  @override
  void initState() {
    super.initState();

    // Initialize the list here, where you can use widget
    _widgetOptions = [
      Dashboard(), // Initialize Dashboard without passing parameters
      Complaint(),
      News(),
    ];

    // toggleMenu(true);
    // _endSideMenuKey.currentState!.isOpened;

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return SideMenu(
      key: _endSideMenuKey,
      inverse: true, // end side menu
      background: appcolor,
      type: SideMenuType.shrinkNSlide,
      menu: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: CustomDrawer(),
      ),
      onChange: (_isOpened) {
        setState(() => isOpened = _isOpened);
      },
      child: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
          actions: [
            Container(
              margin: EdgeInsets.only(left: marginLR),
              child: CircleAvatar(
                backgroundColor: appcolor,
                radius: 16.0,
                child: IconButton(
                  color: dfColor,
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                  ),
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.bottomSlide,
                      title: 'Logout',
                      desc: 'Are you sure you want to logout?',
                      btnCancel: IconButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        icon: Image.asset(
                          'asserts/icons/cross.png',
                          width: 40,
                        ),
                        color: Colors.red,
                      ),
                      btnOk: IconButton(
                        onPressed: () async {
                          //  await

                          await logout();

                          final route =
                              MaterialPageRoute(builder: (context) => LogIn());

                          Navigator.pushAndRemoveUntil(
                              context, route, (route) => false);
                        },
                        icon: Image.asset(
                          'asserts/icons/checked.png',
                          width: 40,
                        ),
                        color: Colors.green,
                      ),
                    ).show();
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: CircleAvatar(
                backgroundColor: lightappcolor,
                radius: 16.0,
                child: IconButton(
                  icon: Icon(
                    Icons.question_mark,
                    color: dfColor,
                    size: 18,
                  ),
                  onPressed: () {
                    customDialog3(context);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: scWidth / 9),
              child: Text(
                "DHA Islamabad",
                style: TextStyle(
                  color: appcolor,
                  fontWeight: FontWeight.w700,
                  fontSize: lgFontSize,
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: marginSet),
              child: IconButton(
                  icon: Image.asset(
                    "asserts/icons/leftmenu.png",
                    width: 30,
                  ),
                  onPressed: () {
                    toggleMenu(true);
                    isOpened = false;
                  }),
            ),
          ],
          backgroundColor: greyColor,
        ),
        body: TabBarView(
          controller: _motionTabBarController,
          physics:
              const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          children: [
            Dashboard(),
            Complaint(),
            News(),
          ],
        ),
        bottomNavigationBar: MotionTabBar(
          labels: ["Dashboard", "Complaint", "News"],
          icons: [
            Icons.dashboard_outlined,
            Icons.error_outline,
            Icons.newspaper
          ],
          initialSelectedTab: initialTabString,
          tabBarColor: appcolor,
          tabIconColor: dfColor,
          tabSelectedColor: lightappcolor,
          tabIconSelectedColor: appcolor,
          tabIconSize: 40,
          tabSize: 50,
          tabIconSelectedSize: 40,
          textStyle: TextStyle(
            color: dfColor,
          ),
          controller: _motionTabBarController,
          onTabItemSelected: (int val) {
            setState(() {
              _motionTabBarController!.index = val;
              if (val == 0) {
                initialTabString = "Dashboard";
              } else if (val == 1) {
                initialTabString = "Complaint";
              } else if (val == 2) {
                initialTabString = "News";
              }
              print("Bottom bar Value : $val");
            });
          },
        ),
      ),
    );
  }
}
