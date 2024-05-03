import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class Gauge extends StatelessWidget {
  const Gauge({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedRadialGauge(
      /// The animation duration.
      duration: const Duration(seconds: 30),
      curve: Curves.elasticOut,

      radius: 60,

      /// Gauge value.
      value: 30,

      /// Optionally, you can configure your gauge, providing additional
      /// styles and transformers.
      axis: GaugeAxis(
          min: 0,
          max: 100,
          degrees: 180,
          style: const GaugeAxisStyle(
            thickness: 20,
            background: Color.fromARGB(255, 115, 138, 216),
            segmentSpacing: 6,
          ),
          pointer: GaugePointer.needle(
            width: 30,
            height: 80,
            color: Colors.blue,
            borderRadius: 50,
          ),

          /// Define the progress bar (optional).
          progressBar: const GaugeProgressBar.rounded(
            color: Color.fromARGB(255, 225, 24, 138),
          ),

          /// Define axis segments (optional).
          segments: [
            const GaugeSegment(
              from: 0,
              to: 33.3,
              color: Color.fromARGB(255, 228, 139, 45),
              cornerRadius: Radius.zero,
            ),
            const GaugeSegment(
              from: 33.3,
              to: 66.6,
              color: Color.fromARGB(255, 115, 145, 219),
              cornerRadius: Radius.zero,
            ),
            const GaugeSegment(
              from: 66.6,
              to: 100,
              color: Color.fromARGB(255, 243, 227, 152),
              cornerRadius: Radius.zero,
            ),
          ]),
    );
  }
}
