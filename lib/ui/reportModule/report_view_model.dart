import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

import '../../data/network/firebase_database.dart';
import '../appModule/assets.dart';

class ReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();

  final TextEditingController referenceNumberController =
      TextEditingController(text: 'SIMP2024-001');
  final TextEditingController clientController =
      TextEditingController(text: 'Springfield Nuclear Power Plant');
  final TextEditingController locationController =
      TextEditingController(text: 'Springfield, USA');
  final TextEditingController nameFSEController =
      TextEditingController(text: 'Homer Simpson');
  final TextEditingController customManagerController =
      TextEditingController(text: 'Montgomery Burns');
  final TextEditingController activityPerformedController =
      TextEditingController(text: 'Reparación del núcleo del reactor nuclear');
  final TextEditingController observationsController = TextEditingController(
      text:
          'La reparación se completó sin incidentes graves. La planta ahora está funcionando a plena capacidad y el Sr. Burns está satisfecho con los resultados.');

  double _uploadProgress = 0.0;

  double get uploadProgress => _uploadProgress;

  Future<bool> generatePDF() async {
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
            )
          ]);
        },
      ),
    );

    final memory = await getInternalStoragePath();
    final file = File('$memory/${referenceNumberController.text}');
    await file.writeAsBytes(await pdf.save());
    return await uploadPDF(file);
  }

  Future<String> getInternalStoragePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> uploadPDF(File file) async {
    bool result = false;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pdfs/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        _uploadProgress = progress;
        print('Proceso de subida de PDF: ${uploadProgress}');
        notifyListeners();
      });

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageRef.getDownloadURL();
        print('Archivo subido! URL de descarga: $downloadURL');
        result = await saveInFirestore(downloadURL);
      });
    } catch (e) {
      print('Error al subir archivo: $e');
    }
    return result;
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(DateTime.now().millisecondsSinceEpoch,
        referenceNumberController.text, downloadURL, false);
    return firebaseDatabase.createTask(taskEntity);
  }
}
