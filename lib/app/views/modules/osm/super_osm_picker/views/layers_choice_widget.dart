import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

// ignore: must_be_immutable
class OSMLayersChoiceWidget extends StatelessWidget {
  final controller;

  OSMLayersChoiceWidget(
    this.controller, {
    super.key,
    this.centerPoint,
  }) {
    centerPoint ??= controller.gpsPosition;
  }

  GeoPoint? centerPoint;

  final _isShown = false.obs;

  bool get isShown => _isShown.value;

  set isShown(bool val) => _isShown.value = val;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SuperDecoratedContainer(
              color: Colors.white70,
              shape: BoxShape.circle,
              child: IconButton(
                color: Colors.black,
                onPressed: () {
                  _isShown.toggle();
                },
                icon: const Icon(Icons.layers),
              ),
            ),
            Obx(() {
              return Row(
                children: [
                  if (isShown) ...[
                    hSpace16,
                    SuperDecoratedContainer(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white70,
                      borderRadius: 24,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.changeTileLayer(CustomTile.publicTransportationOSM());
                              isShown = false;
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox.square(
                                  dimension: Get.width * 0.2,
                                  child: IgnorePointer(
                                    child: Obx(() {
                                      return SuperDecoratedContainer(
                                        borderColor: Colors.amber,
                                        boxShadow: controller.customTile?.sourceName == 'memomapsMapnik'
                                            ? const [BoxShadow(color: Colors.amber, spreadRadius: 2, blurRadius: 2)]
                                            : null,
                                        child: OSMFlutter(
                                          controller: MapController.publicTransportationLayer(
                                            initPosition: controller.gpsPosition,
                                            initMapWithUserPosition: const UserTrackingOption.withoutUserPosition(),
                                          ),
                                          osmOption: const OSMOption(
                                            showZoomController: true,
                                            userTrackingOption: UserTrackingOption.withoutUserPosition(),
                                            isPicker: false,
                                            zoomOption: ZoomOption(initZoom: 12, maxZoomLevel: 12),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const Txt("Transportation", color: Colors.black),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              isShown = false;
                              controller.changeTileLayer(CustomTile.cycleOSM());
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox.square(
                                  dimension: Get.width * 0.2,
                                  child: IgnorePointer(
                                    child: SuperDecoratedContainer(
                                      borderColor: Colors.amber,
                                      boxShadow: controller.customTile?.sourceName == 'cycleMapnik'
                                          ? const [BoxShadow(color: Colors.amber, spreadRadius: 2, blurRadius: 2)]
                                          : null,
                                      child: OSMFlutter(
                                        controller: MapController.cyclOSMLayer(
                                          initPosition: controller.gpsPosition,
                                          initMapWithUserPosition: const UserTrackingOption.withoutUserPosition(),
                                        ),
                                        osmOption: const OSMOption(
                                          showZoomController: true,
                                          userTrackingOption: UserTrackingOption.withoutUserPosition(),
                                          isPicker: false,
                                          zoomOption: ZoomOption(initZoom: 12, maxZoomLevel: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Txt("CycleOSM", color: Colors.black),
                              ],
                            ),
                          ),
                          hSpace4,
                          TextButton(
                            onPressed: () {
                              isShown = false;
                              controller.changeTileLayer(null);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox.square(
                                  dimension: Get.width * 0.2,
                                  child: SuperDecoratedContainer(
                                    borderColor: Colors.amber,
                                    boxShadow:
                                        controller.customTile == null ? const [BoxShadow(color: Colors.amber, spreadRadius: 2, blurRadius: 2)] : null,
                                    child: IgnorePointer(
                                      child: OSMFlutter(
                                        controller: MapController(
                                          initPosition: controller.gpsPosition,
                                          initMapWithUserPosition: const UserTrackingOption.withoutUserPosition(),
                                        ),
                                        osmOption: const OSMOption(
                                          showZoomController: true,
                                          userTrackingOption: UserTrackingOption.withoutUserPosition(),
                                          isPicker: false,
                                          zoomOption: ZoomOption(initZoom: 10, maxZoomLevel: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Txt("OSM", color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
