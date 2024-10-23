import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ProviderS with ChangeNotifier {
  bool _is24time = false;

  // Initial color

  bool get is24time => _is24time;

  set is24time(bool time) {
    _is24time = time;
    notifyListeners();
  }

  Color _pwhite1 = white1;
  Color get pwhite1 => _pwhite1;

  set pwhite1(Color i) {
    _pwhite1 = i;
    notifyListeners();
  }

  String _fomatedDate = '';
  String get fomatedDate => _fomatedDate;
  set fomatedDate(String i) {
    _fomatedDate = i;
    notifyListeners();
  }

  String _userId = '';
  String get userId => _userId;
  set userId(String i) {
    _userId = i;
    notifyListeners();
  }

  List _barcodeListGoogleMap = [];
  List get barcodeListGoogleMap => _barcodeListGoogleMap;
  set barcodeListGoogleMap(List i) {
    _barcodeListGoogleMap = i;
    notifyListeners();
  }

  TextEditingController _scanQnt = TextEditingController();
  TextEditingController get scanQnt => _scanQnt;
  set scanQnt(TextEditingController i) {
    _scanQnt = i;
    notifyListeners();
  }

  String _bImage = '';
  String get bImage => _bImage;
  set bImage(String i) {
    _bImage = i;
    notifyListeners();
  }

  String _bId = '';
  String get bId => _bId;
  set bId(String i) {
    _bId = i;
    notifyListeners();
  }

  String _orderPendingCount = '';
  String get orderPendingCount => _orderPendingCount;
  set orderPendingCount(String i) {
    _orderPendingCount = i;
    notifyListeners();
  }

  double _progress = 0.0;
  double get progress => _progress;
  set progress(double i) {
    _progress = i;
    notifyListeners();
  }

  int _navigateIndex = 0;
  int get navigateIndex => _navigateIndex;
  set navigateIndex(int i) {
    _navigateIndex = i;
    notifyListeners();
  }

  String _staffName = '';
  String get staffName => _staffName;
  set staffName(String i) {
    _staffName = i;
    notifyListeners();
  }

  String _fcmKey = '';
  String get fcmKey => _fcmKey;
  set fcmKey(String i) {
    _fcmKey = i;
    notifyListeners();
  }

  bool _location = false;
  bool get location => _location;
  set location(bool i) {
    _location = i;
    notifyListeners();
  }

  bool _dataLoad = false;
  bool get dataLoad => _dataLoad;
  set dataLoad(bool i) {
    _dataLoad = i;
    notifyListeners();
  }

  bool _isServerDown = false;
  bool get isServerDown => _isServerDown;

  set isServerDown(bool time) {
    _isServerDown = time;
    notifyListeners();
  }

  bool _isUpdtatLocation = false;
  bool get isUpdtatLocation => _isUpdtatLocation;
  set isUpdtatLocation(bool i) {
    _isUpdtatLocation = i;
    notifyListeners();
  }

  bool _isanotherUserLog = false;
  bool get isanotherUserLog => _isanotherUserLog;
  set isanotherUserLog(bool i) {
    _isanotherUserLog = i;
    notifyListeners();
  }

  PermissionStatus? _permission;
  PermissionStatus get permission => _permission!;
  set permission(PermissionStatus i) {
    _permission = i;
    notifyListeners();
  }

  String _lImage = '';
  String get lImage => _lImage;
  set lImage(String i) {
    _lImage = i;
    notifyListeners();
  }

  String _pickId = '';
  String get pickId => _pickId;
  set pickId(String i) {
    _pickId = i;
    notifyListeners();
  }

  String _dpCode = '';
  String get dpCode => _dpCode;
  set dpCode(String i) {
    _dpCode = i;
    notifyListeners();
  }

  String? _rider;
  String get rider => _rider!;
  set rider(String i) {
    _rider = i;
    notifyListeners();
  }

  List _userData = [];
  List get userData => _userData;
  set userData(List i) {
    _userData = i;
    notifyListeners();
  }

  List _dImages64 = [];
  List get dImages64 => _dImages64;
  set dImages64(List i) {
    _dImages64 = i;
    notifyListeners();
  }

  List _homData = [];
  List get homData => _homData;
  set homData(List i) {
    _homData = i;
    notifyListeners();
  }

  List _dRiderList = [];
  List get dRiderList => _dRiderList;
  set dRiderList(List i) {
    _dRiderList = i;
    notifyListeners();
  }

  List<Map<String, dynamic>> _deposit = [];
  List<Map<String, dynamic>> get deposit => _deposit;
  set deposit(List<Map<String, dynamic>> i) {
    _deposit = i;
    notifyListeners();
  }

  bool _isAppbarsheerOpen = false;
  bool get isAppbarsheerOpen => _isAppbarsheerOpen;

  set isAppbarsheerOpen(bool time) {
    _isAppbarsheerOpen = time;
    notifyListeners();
  }

  bool _pickupCansel = false;
  bool get pickupCansel => _pickupCansel;

  set pickupCansel(bool time) {
    _pickupCansel = time;
    notifyListeners();
  }

  VoidCallback? _count;

  VoidCallback get count => _count!;

  void increment(VoidCallback onTap) {
    onTap() {}
    notifyListeners(); // Notify listeners about the change
  }

  bool _readOnly = false;
  bool get readOnly => _readOnly;

  set readOnly(bool time) {
    _readOnly = time;
    notifyListeners();
  }

  double _mapDLat = 0.0;
  double get mapDLat => _mapDLat;

  set mapDLat(double time) {
    _mapDLat = time;
    notifyListeners();
  }

  double _mapDLong = 0.0;
  double get mapDLong => _mapDLong;

  set mapDLong(double time) {
    _mapDLong = time;
    notifyListeners();
  }

  String _noteCount = '';
  String get noteCount => _noteCount;
  set noteCount(String i) {
    _noteCount = i;
    notifyListeners();
  }

  Position? _myLocation;
  Position get myLocation => _myLocation!;
  set myLocation(Position i) {
    _myLocation = i;
    notifyListeners();
  }
}

class ProviderDropDown with ChangeNotifier {
  String _designation = '';
  String get designation => _designation;
  set designation(String i) {
    _designation = i;
    notifyListeners();
  }

  String _branch = '';
  String get branch => _branch;
  set branch(String i) {
    _branch = i;
    notifyListeners();
  }

  String _branchID = '';
  String get branchID => _branchID;
  set branchID(String i) {
    _branchID = i;
    notifyListeners();
  }

  String _emp_Type = '';
  String get emp_Type => _emp_Type;
  set emp_Type(String i) {
    _emp_Type = i;
    notifyListeners();
  }

  String _salaryType = '';
  String get salaryType => _salaryType;
  set salaryType(String i) {
    _salaryType = i;
    notifyListeners();
  }

  String _vehicle_type = '';
  String get vehicle_type => _vehicle_type;
  set vehicle_type(String i) {
    _vehicle_type = i;
    notifyListeners();
  }

  String _bondType = '';
  String get bondType => _bondType;
  set bondType(String i) {
    _bondType = i;
    notifyListeners();
  }

  String _formattedDate = '';
  String get formattedDate => _formattedDate;
  set formattedDate(String i) {
    _bondType = i;
    notifyListeners();
  }
}

// task--------------------------------------------------