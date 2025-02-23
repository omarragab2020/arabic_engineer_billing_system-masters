import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/constants.dart';
import 'package:neuss_utils/utils/helpers.dart';
import 'package:neuss_utils/utils/my_extensions.dart';
import 'package:neuss_utils/widgets/src/super_decorated_container.dart';
import 'package:neuss_utils/widgets/src/txt.dart';

import '../../../../models/location_model.dart';
import '../super_osm_manager.dart';
import 'super_osm_picker_controller.dart';
import 'views/info_card_widget.dart';
import 'views/layers_choice_widget.dart';
import 'views/zoom_widget.dart';

class SuperOSMPicker extends StatelessWidget {
  SuperOSMPicker(
      {
      // required this.controller,
      this.initialPoint,
      this.showLayersBtn = false,
      this.showMyLocationBtn = true,
      this.showInitialLocationBtn = false,
      this.showSearch = true,
      this.showZoomBtn = true,
      this.onBackPressed,
      this.onPicked,
      this.selectText,
      super.key}) {
    // controller.initialPoint = initialPoint;
    // if (controller.currentPosition != null) {
    //   controller.initialPoint = controller.currentPosition;
    // }
    mPrint2('Constructor');
    controller = SuperOSMPickerController(initialPoint: initialPoint)..initAll();
    // Get.create<SuperOSMPickerController>(() => controller, permanent: false);
  }

  late final SuperOSMPickerController controller;
  final bool showMyLocationBtn;
  final bool showInitialLocationBtn;
  final bool showZoomBtn;
  final bool showLayersBtn;
  final bool showSearch;
  final GeoPoint? initialPoint;
  final String? selectText;
  final void Function()? onBackPressed;
  final void Function(LocationModel?)? onPicked;

  final TextEditingController searchController = TextEditingController();

  Future<void> mapIsReady(SuperOSMPickerController controller, context) async {
    controller.lastLocation = null;
    // if (controller.init2) return;
    try {
      // ignore: use_build_context_synchronously

      hideKeyboard(context);
      mShowLoading();
      GeoPoint? currentPosition = initialPoint ?? controller.currentPosition ?? controller.initialPoint ?? controller.gpsPosition;

      if (currentPosition != null) {
        // mPrint('gpsPosition = ${controller.gpsPosition}');
        // mPrint('currentPosition = $currentPosition');
        GeoPoint point = GeoPoint(latitude: currentPosition.latitude, longitude: currentPosition.longitude + 0.000000001);
        controller.lastGeoPoint = point;
        if (controller.gpsPosition != null) {
          await controller.addMarker(controller.gpsPosition!, markerIcon: gpsMarker);
        }

        await controller.mapController?.goToLocation(point);
        // await controller.addMarker(point);

        controller.lastGeoPoint = point;

        // await controller.mapController!.setStaticPosition([currentPosition], 'MyLoc');
        // await controller.mapController!.setMarkerOfStaticPoint(id: 'MyLoc', markerIcon: gpsMarker);
      }
      mHide();
      await controller.addAllMarkers();
      // ignore: use_build_context_synchronously
      hideKeyboard(context);
      controller.init2 = true;
    } catch (e) {
      mPrintError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: controller.mapController == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                OSMFlutter(
                  controller: controller.mapController!,
                  osmOption: OSMOption(
                    showZoomController: true,
                    userTrackingOption: const UserTrackingOption.withoutUserPosition(),
                    isPicker: false,
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_history_rounded,
                          color: Colors.red,
                          size: 96,
                        ),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.double_arrow,
                          size: 48,
                        ),
                      ),
                    ),
                    roadConfiguration: const RoadOption(
                      roadColor: Colors.blueAccent,
                    ),
                  ),
                  // onGeoPointClicked: (p) => {mShowToast(p.toString()), mPrint(p.toString())},
                  // onLocationChanged: (p) => mShowToast(p.toString()),
                  onMapIsReady: (b) async {
                    if (b) {
                      mapIsReady(controller, context);
                    }
                  },
                ),

                ///Center Marker
                Obx(() {
                  if (controller.init2) {
                    return Center(child: SizedBox(width: 24, height: 24, child: pickMarker));
                  }
                  return const SizedBox();
                }),

                Obx(() {
                  mPrint('selectedLocationForTooltip = ${controller.selectedLocationForTooltip}');
                  if (controller.selectedLocationForTooltip == null) return const SizedBox();

                  return Align(
                    alignment: Alignment.center,
                    child: Card(
                      borderOnForeground: true,
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: SuperDecoratedContainer(
                        width: 0.9.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  controller.selectedLocationForTooltip = null;
                                },
                                icon: const Icon(Icons.close)),
                            vSpace32,
                            Txt(controller.selectedLocationForTooltip!.address),
                            const Divider(height: 24, thickness: 2),
                            Txt('Country: ${controller.selectedLocationForTooltip!.country}'),
                            vSpace16,
                            Txt('administrativeArea: ${controller.selectedLocationForTooltip!.administrativeArea}'),
                            vSpace16,
                            Txt('subAdministrativeArea: ${controller.selectedLocationForTooltip!.subAdministrativeArea}'),
                            vSpace16,
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                ///Search
                Positioned(
                  top: 50,
                  right: 16,
                  left: 16,
                  child: Column(
                    children: [
                      if (showSearch)
                        Row(
                          children: [
                            IconButton(
                              onPressed: onBackPressed ?? Get.back,
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                            // Expanded(
                            //   child: Material(
                            //       elevation: 10,
                            //       borderRadius: BorderRadius.circular(16),
                            //       child: TypeAheadField<SearchInfo>(
                            //         textFieldConfiguration: TextFieldConfiguration(
                            //           autofocus: true,
                            //           controller: searchController,
                            //           style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
                            //           // decoration: const InputDecoration(border: OutlineInputBorder()),
                            //         ),
                            //         minCharsForSuggestions: 1,
                            //         hideOnEmpty: true,
                            //         // hideKeyboard: true,
                            //         debounceDuration: 1000.milliseconds,
                            //         suggestionsCallback: (pattern) async {
                            //           mPrint('suggestionsCallback $pattern');
                            //           List<PickResult> list = await SuperOSMManager.searchAbuZeitLocations(pattern);
                            //           mPrint('list = $list');
                            //           return list
                            //               .map(
                            //                 (e) => SearchInfo(address: Address(street: e.formattedAddress), point: e.geometry?.location.toGeoPoint),
                            //               )
                            //               .toList();
                            //         },
                            //         itemBuilder: (context, SearchInfo suggestion) {
                            //           return ListTile(
                            //             title: Text(
                            //               suggestion.address.toString(),
                            //               maxLines: 1,
                            //               overflow: TextOverflow.fade,
                            //             ),
                            //           );
                            //         },
                            //         onSuggestionSelected: (suggestion) {
                            //           mPrint('suggestion ${suggestion.point}');
                            //           hideKeyboard(context);
                            //           searchController.clear();
                            //           if (suggestion.point != null && controller.mapController != null) {
                            //             GeoPoint geoPoint = suggestion.point!;
                            //             geoPoint = geoPoint.copyWith(latitude: geoPoint.longitude, longitude: geoPoint.latitude);
                            //             controller.mapController!.goToLocation(geoPoint);
                            //             mShowToast('Selected (${suggestion.address})');
                            //           }
                            //         },
                            //       )),
                            // ),
                          ],
                        ),
                      vSpace16,

                      ///My location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Zoom
                          // if (showZoomBtn) ZoomWidget(controller) else const SizedBox(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (showInitialLocationBtn && controller.initialPoint != null)
                                Column(
                                  children: [
                                    vSpace16,
                                    if (showLayersBtn) OSMLayersChoiceWidget(controller),
                                    vSpace16,
                                    const SuperDecoratedContainer(
                                      color: Colors.black87,
                                      borderRadius: 8,
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Txt('Initial', color: Colors.white),
                                    ),
                                    FloatingActionButton(
                                      heroTag: 'Hero1',
                                      backgroundColor: Colors.white70,
                                      elevation: 10,
                                      child: const Icon(Icons.my_location_rounded, color: Colors.black),
                                      onPressed: () async {
                                        controller.mapController!.goToLocation(controller.initialPoint!);
                                      },
                                    ),
                                    vSpace16,
                                  ],
                                ),
                              if (showMyLocationBtn && controller.gpsPosition != null)
                                FloatingActionButton(
                                  heroTag: 'Hero2',
                                  backgroundColor: Colors.white70,
                                  elevation: 10,
                                  child: const Icon(Icons.my_location_rounded, color: Colors.black),
                                  onPressed: () async {
                                    controller.mapController!.goToLocation(controller.gpsPosition!);
                                  },
                                ),
                              // Column(
                              //   children: [
                              //     const SuperDecoratedContainer(
                              //       color: Colors.black87,
                              //       borderRadius: 8,
                              //       padding: EdgeInsets.symmetric(horizontal: 8),
                              //       child: Txt('GPS', color: Colors.white),
                              //     ),
                              //     FloatingActionButton(
                              //       heroTag: 'Hero2',
                              //       backgroundColor: Colors.white70,
                              //       elevation: 10,
                              //       child: const Icon(Icons.my_location_rounded, color: Colors.black),
                              //       onPressed: () async {
                              //         controller.mapController!.goToLocation(controller.gpsPosition!);
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ///InfoCard
                Positioned(
                    bottom: Get.height * 0.05,
                    left: Get.width * 0.15,
                    right: Get.width * 0.15,
                    child: InfoCard(controller, selectText, (s) => onPicked?.call(s))),
              ],
            ),
    );
  }
}
