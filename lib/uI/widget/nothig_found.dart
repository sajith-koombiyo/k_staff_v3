import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Center(
        child: Container(
            alignment: Alignment.center,
            height: h / 1.5,
            child: Center(
                child:
                    Lottie.asset('assets/nothing_found.json', height: h / 3))));
  }
}
