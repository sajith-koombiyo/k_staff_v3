import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../app_details/color.dart';
import 'indicator.dart';

class Chart extends StatefulWidget {
  const Chart(
      {super.key,
      required this.oders,
      required this.delivered,
      required this.commission,
      required this.bankAmount,
      required this.data,
      required this.nextDay});
  final String oders;
  final String delivered;
  final String commission;
  final String bankAmount;
  final String nextDay;

  final List data;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int touchedIndex = 0;
  var delivery;
  var oders;
  var monthyRate;
  var other;
  @override
  void initState() {
    delivery = double.parse(widget.delivered);
    oders = double.parse(widget.oders);
    monthyRate = 100 * delivery / oders;
    other = oders - delivery;
    if (monthyRate.toString() == 'NaN' || monthyRate.toString() == 'Infinity') {
      monthyRate = 0.00;
    }
    other.toStringAsFixed(1);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: AnimationConfiguration.synchronized(
        duration: Duration(milliseconds: 900),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromARGB(255, 195, 243, 253),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            color: black1,
                          ),
                          Text(" Monthly Commission  RS   ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: black1,
                                fontSize: 12.dp,
                              )),
                          Text("${widget.commission}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 17.dp,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                centerSpaceColor:
                                    Color.fromARGB(255, 10, 120, 142),
                                sectionsSpace: 2,
                                centerSpaceRadius: 60,
                                sections: showingSections(),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      monthyRate == 'NaN' ||
                                              monthyRate == 'infinity'
                                          ? "0.00%"
                                          : "${monthyRate.toStringAsFixed(2)}%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: white1,
                                        fontSize: 20.dp,
                                      )),
                                  Text("Succses Rate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: white1,
                                        fontSize: 10.dp,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: w / 2,
                            child: Indicator(
                              color: Color.fromARGB(255, 255, 143, 14),
                              text: 'Monthly Oders - ${widget.oders}',
                              isSquare: true,
                            ),
                          ),
                          Indicator(
                            color: Color.fromARGB(255, 19, 164, 21),
                            text: 'Delivered - ${widget.delivered}',
                            isSquare: true,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: w / 2,
                            child: Indicator(
                              color: Color.fromARGB(255, 209, 75, 97),
                              text: 'Other - ${other.toStringAsFixed(0)}',
                              isSquare: true,
                            ),
                          ),
                          SizedBox(
                            child: Indicator(
                              color: Color.fromARGB(255, 196, 72, 237),
                              text: 'Next Day - ${widget.nextDay}',
                              isSquare: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            title: '',
            badgeWidget: Card(
                elevation: 20,
                color: Color.fromARGB(255, 196, 72, 237),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.border_outer_rounded,
                        color: white,
                      ),
                      Text(
                        "  ${widget.nextDay}",
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                )),
            badgePositionPercentageOffset: 1,
            color: Color.fromARGB(255, 196, 72, 237),
            value: 500,
            // title: 'Rs.${(double.parse(outstd)).toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );

        case 1:
          return PieChartSectionData(
            title: '',
            badgeWidget: Card(
                elevation: 20,
                color: Color.fromARGB(255, 209, 75, 97),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: white,
                      ),
                      Text(
                        "  ${other.toStringAsFixed(0)}",
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                )),
            badgePositionPercentageOffset: 1,
            color: Color.fromARGB(255, 209, 75, 97),
            value: 500,

            // title: 'Rs.${(double.parse(outstd)).toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            title: '',
            badgeWidget: Card(
                elevation: 20,
                color: Color.fromARGB(255, 255, 161, 54),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_task_sharp,
                        color: white,
                      ),
                      Text(
                        '   ${widget.oders}',
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                )),
            badgePositionPercentageOffset: 1,
            color: Color.fromARGB(255, 255, 161, 54),
            value: 500,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            title: '',
            badgeWidget: Card(
                elevation: 20,
                color: Color.fromARGB(255, 19, 164, 21),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.next_plan_outlined,
                        color: white,
                      ),
                      Text(
                        '   ${widget.delivered}',
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                )),
            badgePositionPercentageOffset: 1,
            color: Color.fromARGB(255, 19, 164, 21),
            value: 500,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: white,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
