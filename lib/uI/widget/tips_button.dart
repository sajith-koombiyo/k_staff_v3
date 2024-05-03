import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';

class TipButton extends StatefulWidget {
  final IconData icon;
  final bool button;

  const TipButton({Key? key, required this.icon, required this.button})
      : super(key: key);

  @override
  _TipButtonState createState() => _TipButtonState();
}

class _TipButtonState extends State<TipButton>
    with SingleTickerProviderStateMixin {
  bool tap = false;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapCancel: () {
        setState(() {
          tap = false;
        });
      },
      child: widget.button
          ? Stack(
              children: [
                // CircleAvatar(
                //     radius: 25,
                //     backgroundColor: Color.fromARGB(255, 141, 151, 152),
                //     child: Icon(
                //       widget.icon,
                //       size: 30,
                //     )),
                AnimateIcon(
                    key: UniqueKey(),
                    onTap: () {},
                    iconType: IconType.continueAnimation,
                    height: 80,
                    // width: 50,
                    color: Color.fromARGB(255, 255, 255, 255),
                    animateIcon: AnimateIcons.dragRight),
              ],
            )
          : Container(),
    );
  }
}
