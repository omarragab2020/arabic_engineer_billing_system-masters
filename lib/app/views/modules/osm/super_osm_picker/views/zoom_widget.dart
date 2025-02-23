import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ZoomWidget extends StatelessWidget {
  final MapController controller;
  const ZoomWidget(this.controller, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white70), elevation: WidgetStateProperty.all(10)),
          child: const Icon(Icons.add),
          onPressed: () async {
            if (controller.camera.zoom < 20) {
              controller.move(controller.camera.center, controller.camera.zoom + 0.5);
            }
          },
        ),
        ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white70), elevation: WidgetStateProperty.all(10)),
          child: const Icon(Icons.remove),
          onPressed: () async {
            if (controller.camera!.zoom > 0) {
              controller!.move(controller.camera.center, controller.camera.zoom - 0.5);
            }
          },
        ),
      ],
    );
  }
}
