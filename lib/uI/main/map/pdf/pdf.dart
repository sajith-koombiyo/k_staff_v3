import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Pagec

class PDFView {
  Future<Uint8List> makePdf(BuildContext context, Uint8List image) async {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final font = await PdfGoogleFonts.nunitoExtraLight();
    pw.Image image1 = pw.Image(pw.MemoryImage(
      image,
    ));
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('d E MMM yyyy mm:ss a').format(now);
    var formatter = new NumberFormat.currency(locale: "en_US", symbol: "");
    formattedDate;

    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('assets/app 12.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    Icon(Icons.abc);
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.only(top: 12),
                child: pw.Text(
                  'Pickup Summery',
                  style: pw.TextStyle(
                      font: font, fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 20),
                  child: pw.SizedBox(width: w / 2, child: pw.Divider())),
              pw.SizedBox(
                height: 50,
              ),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  formattedDate,
                  style: pw.TextStyle(
                      font: font, fontSize: 17, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Text(
                    'Pickup Quantity',
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    "20",
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Text(
                    'Clint Name',
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    "Darshana Devinda",
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Text(
                    'Address',
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(
                    width: 15,
                  ),
                  pw.Spacer(),
                  pw.Text(
                    "105.05 ihalagama ,kirindiwela,",
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 17,
                        fontWeight: pw.FontWeight.normal),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Container(
                padding: pw.EdgeInsets.only(top: 0),
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        height: h / 7,
                        child: image1,
                      ),
                      pw.SizedBox(width: w / 4, child: pw.Divider()),
                      pw.Text(
                        'Signature',
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ]),
              ),
            ],
          );
        }));
    return pdf.save();
  }
}
