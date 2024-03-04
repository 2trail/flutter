
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class GoToCurrentLocationButton extends StatelessWidget {


  final VoidCallback? onPressed;


  final bool mini;
  final double padding;
  final RoundedRectangleBorder shape;
  final Alignment alignment;
  final Color? goLocationColor;
  final IconData goToIcon;
  final Color? goToIconColor;
  static const _fitBoundsPadding = EdgeInsets.all(12);

  const GoToCurrentLocationButton({
    super.key,
    this.mini = true,
    this.padding = 2.0,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    this.alignment = Alignment.bottomLeft,
    this.goToIconColor,
    this.goToIcon = Icons.gps_fixed_rounded,
    this.onPressed,
    this.goLocationColor,

  });



  @override
  Widget build(BuildContext context) {

    final controller = MapController.of(context);
    final camera = MapCamera.of(context);
    final theme = Theme.of(context);

    return Align(
      alignment: alignment,
      child: Padding(
        padding:
        EdgeInsets.only(left: padding, top: padding, right: padding),
        child: FloatingActionButton(
          heroTag: 'goToCurrentLocationButton',
          mini: mini,
          shape: shape,
          backgroundColor: goLocationColor ?? theme.colorScheme.surface,
          onPressed: onPressed,
          child: Icon(goToIcon,
              color: goToIconColor ?? theme.iconTheme.color),
        ),
      ),
    );
  }
}
