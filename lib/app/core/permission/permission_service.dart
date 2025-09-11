import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPhotosPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }
    return status.isGranted;
  }
}
