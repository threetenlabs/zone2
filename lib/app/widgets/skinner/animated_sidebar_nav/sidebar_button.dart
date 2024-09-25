import 'dart:core';

import 'package:app/app/style/palette.dart';
import 'package:app/app/widgets/skinner/animated_nav_bar/clipped_view.dart';
import 'package:app/app/widgets/skinner/animated_nav_bar/navbar.dart';
import 'package:app/app/widgets/skinner/ui/rotation_3d.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Handle the transition between selected and de-deselected, by animating it's own width,
// and modifying the color/visibility of some child widgets
class SideBarButton extends StatefulWidget {
  final NavBarItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const SideBarButton(this.data, this.isSelected, {super.key, required this.onTap});

  @override
  SideBarButtonState createState() => SideBarButtonState();
}

class SideBarButtonState extends State<SideBarButton> with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimController;
  late bool _wasSelected = widget.isSelected;
  final double _animScale = 1;
  late Palette _palette;
  @override
  void initState() {
    //Create a tween + controller which will drive the icon rotation
    int duration = (350 / _animScale).round();
    _palette = Get.find<Palette>();
    _iconAnimController = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );
    Tween<double>(begin: 0, end: 1)
        .animate(_iconAnimController)
        //Listen for tween updates, and rebuild the widget tree on each tick
        .addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _startAnimIfSelectedChanged(widget.isSelected);
    //Create our main button, a Row, with an icon and some text
    //Inject the data from our widget.data property
    var content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Rotate the icon using the current animation value
        Rotation3d(
          rotationY: 180 * _iconAnimController.value,
          child: Icon(
            widget.data.icon,
            size: 24,
            color: widget.isSelected ? _palette.reallyDarkBackGround : const Color(0xffcccccc),
          ),
        ),
        //Add some hz spacing
        const SizedBox(width: 12),
        //Label
        Text(
          widget.data.title,
          style: TextStyle(color: _palette.reallyDarkBackGround),
        ),
      ],
    );

    //Wrap btn in GestureDetector so we can listen to taps
    return GestureDetector(
      onTap: () => widget.onTap(),
      //Wrap in a bit of extra padding to make it easier to tap
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16, right: 4, left: 4),
        //Wrap in an animated container, so changes to width & color automatically animate into place
        child: AnimatedContainer(
          alignment: Alignment.center,
          //Determine target width, selected item is wider
          width: widget.isSelected ? widget.data.width : 56,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          duration: Duration(milliseconds: (700 / _animScale).round()),
          //Use BoxDecoration top create a rounded container
          decoration: BoxDecoration(
            color: widget.isSelected ? widget.data.selectedColor : _palette.unselectedButton,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          //Wrap the row in a ClippedView to suppress any overflow errors if we momentarily exceed the screen size
          child: ClippedView(
            child: content,
          ),
        ),
      ),
    );
  }

  void _startAnimIfSelectedChanged(bool isSelected) {
    if (_wasSelected != widget.isSelected) {
      //Go forward or reverse, depending on the isSelected state
      widget.isSelected ? _iconAnimController.forward() : _iconAnimController.reverse();
    }
    _wasSelected = widget.isSelected;
  }
}
