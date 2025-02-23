import 'package:almuandes_billing_system/app/views/modules/osm/super_osm_picker/views/zoom_widget.dart';
import 'package:almuandes_billing_system/core/utils/app_extensions.dart';
import 'package:almuandes_billing_system/core/utils/app_helpers.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/super_edit_text.dart';
import 'package:neuss_utils/widgets/src/super_scaffold.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:neuss_utils/home/home.dart';
import 'package:neuss_utils/utils/my_extensions.dart';

import '../../../../flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'stations_controller.dart';
import 'views/station_row_view.dart';

class StationsScreen extends StatelessWidget {
  StationsScreen({super.key});

  final StationsController controller = Get.put(StationsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: ThemeService.to.brightness,
        systemNavigationBarColor: Get.theme.colorScheme.surface));
    return SuperScaffold(
      onWillPop: controller.onWillPop,
      // showBackBtn: true,
      // backBtnBgColor: Colors.white70,
      // backBtnIconColor: Get.theme.primaryColor,
      backBtnPadding: 8,
      body: Obx(() {
        return SlidingBox(
          controller: controller.boxController,
          minHeight: 0.4.h,
          maxHeight: 0.8.h,
          color: Get.theme.colorScheme.surface,
          style: BoxStyle.shadow,

          backdrop: Backdrop(
            overlay: true,
            color: Get.theme.colorScheme.surface,
            body: mapViewBackdrop(),
          ),
          body: bottomSheetBody(),
          collapsed: true,
          onBoxShow: () {
            // setState(() {});
            controller.refreshAll();
          },

          onBoxOpen: () {
            // setState(() {});
            controller.refreshAll();
          },
          onBoxClose: () {
            // setState(() {});
            controller.refreshAll();
          },

          // collapsedBody: _collapsedBody(),
        );
      }),
    );
  }

  Widget mapViewBackdrop() {
    return Obx(() {
      return Stack(
        children: [
          PopupScope(
            popupController: controller.popupController,
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.defaultLatLng,
                initialZoom: 10,
                interactionOptions: const InteractionOptions(
                    enableMultiFingerGestureRace: true),
                onTap: (TapPosition tapPosition, LatLng point) =>
                    controller.popupController.hideAllPopups(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.never,
                  alignDirectionOnUpdate: AlignOnUpdate.never,
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    // maxClusterRadius: 60,
                    size: const Size(50, 50),
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(50),
                    maxZoom: 15,
                    markers: controller.markers,
                    popupOptions: PopupOptions(
                        buildPopupOnHover: true,
                        popupController: controller.popupController,
                        popupSnap: PopupSnap.markerTop,
                        popupBuilder: popupBuilder),
                    builder: clusterBuilder,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 10,
              child: ZoomWidget(controller.mapController)),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40, right: 10),
              child: FloatingActionButton(
                backgroundColor: Colors.white70,
                elevation: 10,
                onPressed: () {
                  controller.moveToUserLocation();
                  // boxController.isBoxOpen ? boxController.closeBox() : boxController.openBox();
                },
                child: Icon(Icons.my_location, color: Get.theme.primaryColor),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget bottomSheetBody() {
    return Obx(() {
      return SizedBox(
        width: 1.w,
        height: !controller.boxController.isAttached
            ? 0.2.h
            : controller.boxController.isBoxOpen
                ? 0.8.h
                : 0.4.h,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.selectedStation != null
                ? [
                    vSpace8,
                    Align(
                      alignment: LanguageService.to.alignmentReverse,
                      child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.selectedStation = null;
                          }),
                    ),
                    Center(
                      child: Txt('(${controller.selectedStation!.id})',
                          isBold: true, letterSpacing: 2, fontSize: 18),
                    ),
                    Center(
                      child: Txt('(${controller.selectedStation!.name})',
                          isBold: true, letterSpacing: 2, fontSize: 18),
                    ),
                    vSpace8,
                    Txt(controller.selectedStation!.description),
                    vSpace4,
                    Txt(controller.selectedStation!.address),
                    vSpace4,
                    Txt('${controller.selectedStation!.distanceKM?.toStringAsFixed(2)} KM * ${controller.selectedStation!.durationMin?.toStringAsFixed(2)} minutes'),
                  ]
                : [
                    vSpace8,
                    SuperEditText(
                      controller.textEditingController,
                      hint: 'Stations, services, or areas...',
                      prefixIconData: Icons.search,
                      suffixWidget:
                          Icon(Icons.widgets, color: Get.theme.primaryColor),
                      onFocusChange: (b) {
                        if (b) controller.boxController.openBox();
                      },
                      onChanged: (s) {
                        if (s == null) return;
                        controller.displayStations = controller.allStations
                            .where((e) =>
                                e.name?.contains(s) == true ||
                                e.description?.contains(s) == true ||
                                e.address?.contains(s) == true)
                            .toList();
                      },
                    ),
                    // vSpace16,
                    // Center(
                    //   child: ToggleButtons(
                    //     constraints:
                    //         BoxConstraints(minWidth: 0.4.w, minHeight: 30),
                    //     isSelected: [
                    //       !controller.selectedAreas,
                    //       controller.selectedAreas,
                    //     ],
                    //     children: const [
                    //       Txt('Stations and Services', fontSize: 16),
                    //       Txt('Areas', fontSize: 16),
                    //     ],
                    //     onPressed: (n) {
                    //       controller.selectedAreas = n == 1;
                    //     },
                    //   ),
                    // ),
                    AppHelpers.appDivider(16),
                    Expanded(
                      child: ListView.separated(
                        // shrinkWrap: true,
                        itemCount: controller.displayStations.length,
                        itemBuilder: (BuildContext context, int index) =>
                            InkWell(
                                onTap: () {
                                  controller.selectedStation =
                                      controller.displayStations[index];
                                  Marker? marker = controller.getStationMarker(
                                      controller.selectedStation!.id);
                                  if (marker != null) {
                                    controller.moveToLocation(marker.point,
                                        zoom: 15);
                                  }
                                },
                                child: StationRowView(
                                    controller.displayStations[index])),
                        separatorBuilder: (BuildContext context, int index) =>
                            AppHelpers.appDivider(),
                      ),
                    ),
                    vSpace16,
                  ],
          ),
        ),
      );
    });
  }

  Widget popupBuilder(BuildContext _, Marker marker) {
    return SuperDecoratedContainer(
      width: 0.7.w,
      borderRadius: 16,
      // height: 100,
      color: Get.theme.colorScheme.onPrimary,
      padding: 8.allPadding,
      child: GestureDetector(
        onTap: () => [
          debugPrint('Popup tap!'),
          controller.selectedStation = controller.getMarkerStation(marker)
        ],
        child: Txt(
          'Popup for marker\n'
          '(${marker.id})'
          '${marker.point.toJson()['coordinates']}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget clusterBuilder(BuildContext context, List<Marker> markers) {
    return SuperDecoratedContainer(
      shape: BoxShape.circle,
      color: Get.theme.primaryColor,
      child: Center(
        child: Txt(
          '${markers.length}',
          color: Colors.white,
        ),
      ),
    );
  }
}
