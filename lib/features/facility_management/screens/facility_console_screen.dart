import 'package:flutter/material.dart';

import '../../../data/models/facility_model.dart';
import 'facility_dashboard_screen.dart';

export 'facility_dashboard_screen.dart' show facilityStatsProvider;

class FacilityConsoleScreen extends StatelessWidget {
  const FacilityConsoleScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  Widget build(BuildContext context) {
    return FacilityDashboardScreen(
      initialKind: kind,
      initialFacilityId: facilityId,
    );
  }
}
