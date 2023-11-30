import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/src/dashboard/providers/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (_, controller, __) => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex,
          children: controller.screens,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            //background color
            canvasColor: Colours.bottomNavigationBackgroundColor,
            //disabled animations
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex,
            selectedItemColor: Colours.activeIconColor,
            unselectedItemColor: Colours.inactiveIconColor,
            selectedFontSize: 10.sp,
            unselectedFontSize: 10.sp,
            elevation: 0,
            onTap: controller.changeIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.currentIndex == 0
                      ? 'assets/icons/card_active_icon.svg'
                      : 'assets/icons/card_inactive_icon.svg',
                  height: 23.h,
                  width: 34.w,
                ),
                label: 'Card',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.currentIndex == 1
                      ? 'assets/icons/savings_active_icon.svg'
                      : 'assets/icons/savings_inactive_icon.svg',
                  height: 23.h,
                  width: 34.w,
                ),
                label: 'Savings',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 23.w,
                  color: controller.currentIndex == 2
                      ? Colours.activeIconColor
                      : Colours.inactiveIconColor,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
