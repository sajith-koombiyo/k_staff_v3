import 'package:flutter/material.dart';

class AppSize {
  height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
