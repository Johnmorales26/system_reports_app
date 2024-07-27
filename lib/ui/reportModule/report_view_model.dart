import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import '../../data/network/firebase_database.dart';
import '../appModule/assets.dart';

class ReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();

  final TextEditingController referenceNumberController =
      TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameFSEController = TextEditingController();
  final TextEditingController customManagerController = TextEditingController();
  final TextEditingController activityPerformedController =
      TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  double _uploadProgress = 0.0;

  double get uploadProgress => _uploadProgress;

  void updateSelectedImage(String url) {
    urlController.text = url;
    notifyListeners();
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<bool> generatePDF(File signature) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pw.TableRow buildTableRow(String label, String value, pw.Font ttf) {
      return pw.TableRow(children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label, style: pw.TextStyle(font: ttf)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value, style: pw.TextStyle(font: ttf)),
        ),
      ]);
    }

    final logo = await rootBundle.load(Assets.imgSilbec);
    final imageBytes = logo.buffer.asUint8List();
    final signatureUint = await fileToUint8List(signature);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Row(children: [
              pw.Expanded(child: pw.Container()),
              pw.Image(pw.MemoryImage(imageBytes), width: 150, height: 100)
            ]),
            pw.SizedBox(height: Dimens.commonPaddingDefault),
            pw.Table(
              border: pw.TableBorder.all(width: 1.0, color: PdfColors.black),
              children: [
                buildTableRow('Número de referencia:',
                    referenceNumberController.text.toString().trim(), ttf),
                buildTableRow('Nombre FSE:',
                    nameFSEController.text.toString().trim(), ttf),
                buildTableRow(
                    'Cliente:', clientController.text.toString().trim(), ttf),
                buildTableRow('Gerente del Cliente:',
                    customManagerController.text.toString().trim(), ttf),
                buildTableRow('Ubicación:',
                    locationController.text.toString().trim(), ttf),
                buildTableRow('Actividad realizada:',
                    activityPerformedController.text.toString().trim(), ttf),
                buildTableRow('Observaciones:',
                    observationsController.text.toString().trim(), ttf),
              ],
            ),
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(signatureUint),
                      width: 150, height: 100),
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Divider()),
                  pw.Text('Firma')
                ])
          ]);
        },
      ),
    );

    return generateFile(pdf, referenceNumberController.text, this);
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(DateTime.now().millisecondsSinceEpoch,
        referenceNumberController.text, downloadURL, false,
        image: urlController.text);
    return firebaseDatabase.createTask(taskEntity);
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  bool validateControllers() {
    if (referenceNumberController.text.trim().isEmpty ||
        clientController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        nameFSEController.text.trim().isEmpty ||
        customManagerController.text.trim().isEmpty ||
        activityPerformedController.text.trim().isEmpty ||
        observationsController.text.trim().isEmpty ||
        urlController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void clearControllers() {
    referenceNumberController.clear();
    clientController.clear();
    locationController.clear();
    nameFSEController.clear();
    customManagerController.clear();
    activityPerformedController.clear();
    observationsController.clear();
    urlController.clear();
  }
}
