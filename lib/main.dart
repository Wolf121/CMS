import 'package:dha_resident_app/view/screens/splach/splach.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Upgrader.clearSavedSettings(); // only show during testing
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resident App',
      theme: ThemeData(
          // Set your theme here
          ),
      home: AppUpdate(),
    );
    //Hello
  }
}

class AppUpdate extends StatefulWidget {
  const AppUpdate({super.key});

  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
        upgrader: Upgrader(
          showIgnore: false,
          showLater: false,
          showReleaseNotes: false,
          canDismissDialog: false,
          durationUntilAlertAgain: const Duration(seconds: 1),
        ),
        child: Splach());
  }
}
