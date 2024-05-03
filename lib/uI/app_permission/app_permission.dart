import 'package:flutter/material.dart';
import 'package:flutter_application_2/uI/splash/splash.dart';
import 'package:permission_request_page/permission_request_page.dart';

class AppPermission extends StatefulWidget {
  const AppPermission({super.key});

  @override
  State<AppPermission> createState() => _AppPermissionState();
}

class _AppPermissionState extends State<AppPermission> {
  List<PermissionData> _kPermission = [
    PermissionData(
      permissionType: PermissionType.location,
      description: 'Required to provide location services.',
      isNecessary: true,
    ),
    PermissionData(
      permissionType: PermissionType.photos,
      description: 'Required to access the gallery of the smartphone.',
      isNecessary: false,
    ),
    PermissionData(
      permissionType: PermissionType.camera,
      description: 'Required to access the camera ',
      isNecessary: false,
    ),
    PermissionData(
      permissionType: PermissionType.sms,
      description:
          'Required to access the SMS to get an OTP for user verification.',
      isNecessary: false,
    ),
  ];
  Future<InitResult> _initFunction() async {
    InitResult initResult;
    try {
      // Write your app initialization code.
      initResult = const InitResult(complete: true);
    } catch (error, stackTrace) {
      // Write code to handle app initialization errors.
      initResult =
          InitResult(complete: false, error: error, stackTrace: stackTrace);
    }

    // If the complete value of InitResult is true, it navigates to the nextPage.
    return initResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PermissionRequestPage(
          appIconAssetPath: 'assets/logo-01-01.png',
          permissions: _kPermission,
          initFunction: _initFunction,
          nextPage: Splash()),
    );
  }
}
