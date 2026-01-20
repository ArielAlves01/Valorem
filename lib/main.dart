import 'package:flutter/material.dart';
import 'package:valoremidle/core/services/provinder_list.dart';
import 'package:intl/intl.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(
      listProviders()
  );
}

