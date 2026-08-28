import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// A tagged map marker. Colour and icon carry the meaning: pickup, dropoff,
/// courier or vendor.
class MapPin {
  const MapPin({
    required this.point,
    required this.icon,
    required this.color,
    this.label,
    this.onTap,
  });

  final LatLng point;
  final IconData icon;
  final Color color;
  final String? label;
  final VoidCallback? onTap;
}

/// The one map widget in the app — OpenStreetMap tiles through flutter_map, so
/// the same code runs on mobile and in the admin web dashboard.
class SajiMap extends StatelessWidget {
  const SajiMap({
    required this.center,
    super.key,
    this.controller,
    this.zoom = 14,
    this.pins = const [],
    this.route = const [],
    this.onTap,
    this.onPositionChanged,
    this.interactive = true,
    this.tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  });

  final LatLng center;
  final MapController? controller;
  final double zoom;
  final List<MapPin> pins;
  final List<LatLng> route;
  final ValueChanged<LatLng>? onTap;
  final ValueChanged<LatLng>? onPositionChanged;
  final bool interactive;
  final String tileUrl;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        onTap: onTap == null ? null : (_, point) => onTap!(point),
        onPositionChanged: (position, hasGesture) {
          if (hasGesture) onPositionChanged?.call(position.center);
        },
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: 'com.saji.delivery',
          maxZoom: 19,
        ),
        if (route.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(points: route, strokeWidth: 4, color: AppColors.primaryGreen),
            ],
          ),
        if (pins.isNotEmpty)
          MarkerLayer(
            markers: [
              for (final pin in pins)
                Marker(
                  point: pin.point,
                  width: 120,
                  height: 64,
                  alignment: Alignment.topCenter,
                  child: _PinMarker(pin: pin),
                ),
            ],
          ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}

class _PinMarker extends StatelessWidget {
  const _PinMarker({required this.pin});

  final MapPin pin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pin.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: pin.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: AppShadows.card,
            ),
            child: Icon(pin.icon, color: Colors.white, size: 18),
          ),
          if (pin.label != null)
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.small),
                boxShadow: AppShadows.card,
              ),
              child: Text(
                pin.label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.badge,
              ),
            ),
        ],
      ),
    );
  }
}
