import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestCallPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted = statuses[Permission.camera]?.isGranted ?? false;
    final micGranted = statuses[Permission.microphone]?.isGranted ?? false;

    if (!cameraGranted || !micGranted) {
      if (await Permission.camera.isPermanentlyDenied ||
          await Permission.microphone.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    return true;
  }
}
