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

  double _progress = 0.0;
  double get progress => _progress;
  set progress(double i) {
    _progress = i;
    notifyListeners();
  }

  String _staffName = '';
  String get staffName => _staffName;
  set staffName(String i) {
    _staffName = i;
    notifyListeners();
  }

  bool _location = false;
  bool get location => _location;
  set location(bool i) {
    _location = i;
    notifyListeners();
  }

  bool _isUpdtatLocation = false;
  bool get isUpdtatLocation => _isUpdtatLocation;
  set isUpdtatLocation(bool i) {
    _isUpdtatLocation = i;
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

  String _dpCode = '';
  String get dpCode => _dpCode;
  set dpCode(String i) {
    _dpCode = i;
    notifyListeners();
  }

  List _userData = [];
  List get userData => _userData;
  set userData(List i) {
    _userData = i;
    notifyListeners();
  }

  List _homData = [];
  List get homData => _homData;
  set homData(List i) {
    _homData = i;
    notifyListeners();
  }

  List<Map<String, dynamic>> _deposit = [];
  List<Map<String, dynamic>> get deposit => _deposit;
  set deposit(List<Map<String, dynamic>> i) {
    _deposit = i;
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