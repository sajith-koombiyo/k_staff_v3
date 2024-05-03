import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/uI/main/map/pdf/pdf.dart';
import 'package:flutter_application_2/uI/main/map/utilize.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  // initialize the signature controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => log('Value changed'));
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data = await _controller.toPngBytes(
      height: 300,
    );
    if (data == null) {
      return;
    }

    if (!mounted) return;
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async =>
            PDFView().makePdf(context, data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Signature(
        key: const Key('signature'),
        controller: _controller,
        height: 300,
        backgroundColor: Colors.grey[300]!,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //SHOW EXPORTED IMAGE IN NEW ROUTE
              IconButton(
                key: const Key('exportPNG'),
                icon: const Icon(Icons.image),
                color: Colors.blue,
                onPressed: () async {
                  exportImage(context);
                },
                tooltip: 'Export Image',
              ),
              // IconButton(
              //   key: const Key('exportSVG'),
              //   icon: const Icon(Icons.share),
              //   color: Colors.blue,
              //   onPressed: () => exportSVG(context),
              //   tooltip: 'Export SVG',
              // ),
              IconButton(
                icon: const Icon(Icons.undo),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.undo());
                },
                tooltip: 'Undo',
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.redo());
                },
                tooltip: 'Redo',
              ),
              //CLEAR CANVAS
              IconButton(
                key: const Key('clear'),
                icon: const Icon(Icons.clear),
                color: Colors.blue,
                onPressed: () {
                  setState(() => _controller.clear());
                },
                tooltip: 'Clear',
              ),
              // STOP Edit
              // IconButton(
              //   key: const Key('stop'),
              //   icon: Icon(
              //     _controller.disabled ? Icons.pause : Icons.play_arrow,
              //   ),
              //   color: Colors.blue,
              //   onPressed: () {
              //     setState(() => _controller.disabled = !_controller.disabled);
              //   },
              //   tooltip: _controller.disabled ? 'Pause' : 'Play',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
