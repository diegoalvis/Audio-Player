import 'package:flutter/material.dart';

class ImageAnimatedContainer extends StatefulWidget {
  @override
  _ImageAnimatedContainerState createState() => _ImageAnimatedContainerState();

  late double _width;
  late String _frontImagePath;

  ImageAnimatedContainer({required String frontImagePath, double width = 40}) {
    this._width = width;
    this._frontImagePath = frontImagePath;
  }
}

class _ImageAnimatedContainerState extends State<ImageAnimatedContainer> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.

  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    // print(double.infinity);
    return Padding(
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        // Use the properties stored in the State class.
        width: widget._width,
        height: 40,

        decoration: BoxDecoration(
          // color: Colors.yellow.withOpacity(0.5),
          borderRadius: _borderRadius,
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomLeft,
            scale: 1,
            image: AssetImage(
              widget._frontImagePath,
            ),
          ),
        ),
        // Define how long the animation should take.
        duration: Duration(milliseconds: 200),
        // Provide an optional curve to make the animation feel smoother.
      ),
    );
  }
}