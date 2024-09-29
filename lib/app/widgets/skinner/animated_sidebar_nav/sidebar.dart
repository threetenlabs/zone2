import 'package:zone2/app/style/palette.dart';
import 'package:zone2/app/widgets/skinner/animated_nav_bar/navbar.dart';
import 'package:zone2/app/widgets/skinner/animated_sidebar_nav/sidebar_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../animated_nav_bar/clipped_view.dart';

class AnimatedSideBar extends StatelessWidget {
  final ValueChanged<int> itemTapped;
  final int currentIndex;
  final List<NavBarItemData> items;
  const AnimatedSideBar(
      {super.key, required this.items, required this.itemTapped, this.currentIndex = 0});

  NavBarItemData? get selectedItem =>
      currentIndex >= 0 && currentIndex < items.length ? items[currentIndex] : null;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<Palette>();

    //For each item in our list of data, create a NavBtn widget
    List<Widget> buttonWidgets = items.map((data) {
      //Create a button, and add the onTap listener
      return SideBarButton(data, data == selectedItem, onTap: () {
        //Get the index for the clicked data
        var index = items.indexOf(data);
        //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
        itemTapped(index);
      });
    }).toList();

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: palette.darkBackGround,
        //Add some drop-shadow to our navbar, use 2 for a slightly nicer effect
        boxShadow: const [
          BoxShadow(blurRadius: 16, color: Colors.black12),
          BoxShadow(blurRadius: 24, color: Colors.black12),
        ],
      ),
      alignment: Alignment.center,

      //Clip the row of widgets, to suppress any overflow errors that might occur during animation
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ClippedView(
          child: SingleChildScrollView(
            child: Column(
              //Center buttons horizontally
              mainAxisAlignment: MainAxisAlignment.center,
              // Inject a bunch of btn instances into our row
              children: buttonWidgets,
            ),
          ),
        ),
      ),
    );
  }
}
