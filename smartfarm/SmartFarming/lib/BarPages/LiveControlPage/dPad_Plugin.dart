import 'package:flutter/material.dart';
import 'dart:math' as math;


class DPad extends StatelessWidget {

  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final VoidCallback onTapUp;
  final VoidCallback onTapDown;
  final VoidCallback onTapMiddle;
  final Color? backgroundColor;
  final double ratioOfRadius;
  final Color iconColor;
  final Color? containerColor;

  final double size;
  final double? interCircleSize;
  final double spaceBetween;
  final double sizeOfIcon;


  const DPad({
    super.key,
    this.onTapLeft = _defaultOnTapLeft,
    this.onTapRight = _defaultOnTapRight,
    this.onTapUp = _defaultOnTapUp,
    this.onTapDown = _defaultOnTapDown,
    this.onTapMiddle = _defaultOnTapMiddle,
    this.size = 200,
    this.spaceBetween = 5,
    this.interCircleSize,
    this.sizeOfIcon = 50,
    this.backgroundColor ,
    this.ratioOfRadius =2,
    this.iconColor = Colors.white,
    this.containerColor,

  });

  static void _defaultOnTapLeft() {
    print("taped left");
  }
  static void _defaultOnTapRight() {
    print("taped right");
  }
  static void _defaultOnTapUp() {
    print("taped up");
  }
  static void _defaultOnTapDown() {
    print("taped down");
  }
  static void _defaultOnTapMiddle() {
    print("taped middle");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size+spaceBetween,
      height: size +spaceBetween,


      color: containerColor,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: interCircleSize ?? size*0.4,
              height: interCircleSize ?? size*0.4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Material(
                color: backgroundColor ?? Colors.blue.withOpacity(0.3),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onTapMiddle,
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.pause_rounded,
                    size: sizeOfIcon,
                    color:  iconColor,
                  ),
                ),
              ),
            ),
          ),

          Transform.rotate(
            angle: (math.pi /180) *45,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: DPadSingleChild(degree: 0, size: size/2,onTap: onTapDown
                      ,sizeOfIcon:sizeOfIcon,backgroundColor:backgroundColor,ratioOfRadius: ratioOfRadius,iconColor: iconColor),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: DPadSingleChild(degree: 90, size: size/2,onTap: onTapLeft
                      ,sizeOfIcon:sizeOfIcon,backgroundColor:backgroundColor,ratioOfRadius: ratioOfRadius,iconColor: iconColor),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: DPadSingleChild(degree: 180, size: size/2,onTap: onTapUp
                      ,sizeOfIcon:sizeOfIcon,backgroundColor:backgroundColor,ratioOfRadius: ratioOfRadius,iconColor: iconColor),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: DPadSingleChild(degree: 270, size: size/2,onTap: onTapRight
                      ,sizeOfIcon:sizeOfIcon,backgroundColor:backgroundColor,ratioOfRadius: ratioOfRadius,iconColor: iconColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DPadSingleChild extends StatelessWidget {

  final double degree;
  final double ratioOfRadius;
  final Color iconColor;
  final IconData icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double size;
  final double sizeOfIcon;



  const DPadSingleChild({
    super.key,
    this.degree = 135,
    this.ratioOfRadius = 2.0,
    this.iconColor = Colors.white,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.backgroundColor,
    this.onTap = _defaultOnTap,
    this.size = 100,
    this.sizeOfIcon = 50,

  });


  static void _defaultOnTap() {
    print("Default onTap");
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (math.pi /180) *degree,
      origin: Offset.zero,
      child: ClipPath(
        clipper: DirectionalPadCustomClipper(ratioOfRadius: ratioOfRadius),
        child: Material(
          color: backgroundColor ?? Colors.blue.withOpacity(0.3),
          clipBehavior: Clip.none,
          child: InkWell(
            onTap: onTap,
            child: Ink(//sizedBox
              height: size,
              width: size,
              //color: backgroundColor,
              child: Center(
                child: Transform.rotate(
                  angle: (math.pi /180) *(225),
                  child: Icon(
                    icon,
                    size: sizeOfIcon,
                    color: iconColor,
                  ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class DirectionalPadCustomClipper extends CustomClipper<Path>{
  final double ratioOfRadius;
  DirectionalPadCustomClipper({
    this.ratioOfRadius = 2.0,
  });


  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height/ratioOfRadius);//    path.lineTo(0, size.height/3);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, 0);
    path.lineTo(size.width/ratioOfRadius, 0);
    path.quadraticBezierTo(size.width/ratioOfRadius, size.height/ratioOfRadius, 0,size.height/ratioOfRadius);



    //path.quadraticBezierTo(size.width/2, size.height, size.width, size.height*0.8);

    //path.lineTo(size.width, size.height*0.8);
    //path.lineTo((size.width/6)*5, 0);

    return path;
  }
}