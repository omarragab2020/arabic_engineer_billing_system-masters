import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../super_osm_picker_controller.dart';

class RoadTypeChoiceWidget extends StatelessWidget {
  final SuperOSMPickerController controller;
  final Function(RoadType road) setValueCallback;

  const RoadTypeChoiceWidget(
    this.controller, {
    super.key,
    required this.setValueCallback,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: PopScope(
        canPop: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 64,
            width: 196,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setValueCallback(RoadType.car);
                    Navigator.pop(context, RoadType.car);
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car),
                      Text("Car"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setValueCallback(RoadType.bike);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.directions_bike),
                      Text("Bike"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setValueCallback(RoadType.foot);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.directions_walk),
                      Text("Foot"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
