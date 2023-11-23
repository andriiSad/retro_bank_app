import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
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
      builder: (_, controller, __) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: IndexedStack(
            index: controller.currentIndex,
            children: controller.screens,
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.grey[200],
              elevation: 0,
              onTap: controller.changeIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 0
                        ? IconlyBold.home
                        : IconlyLight.home,
                    color: controller.currentIndex == 0
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: 'Home',
                  backgroundColor: Colours.whiteColour,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 1
                        ? IconlyBold.send
                        : IconlyLight.send,
                    color: controller.currentIndex == 1
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: 'Materials',
                  backgroundColor: Colours.whiteColour,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 2
                        ? IconlyBold.document
                        : IconlyLight.document,
                    color: controller.currentIndex == 2
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: 'Transactions',
                  backgroundColor: Colours.whiteColour,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    controller.currentIndex == 3
                        ? IconlyBold.setting
                        : IconlyLight.setting,
                    color: controller.currentIndex == 3
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: 'Settings',
                  backgroundColor: Colours.whiteColour,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
