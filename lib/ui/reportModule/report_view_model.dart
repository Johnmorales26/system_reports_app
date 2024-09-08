import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/expensesReportModule/pdf_generator.dart';
import 'package:system_reports_app/ui/reportModule/models/customer_data.dart';
import 'package:system_reports_app/ui/reportModule/models/trip_data.dart';
import 'package:system_reports_app/ui/reportModule/models/work_schedule.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import '../../data/network/firebase_database.dart';
import '../appModule/assets.dart';

class ReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();

  final customerData = CustomerData(
    referenceNumberController: TextEditingController(),
    clientNameController: TextEditingController(),
    managerNameController: TextEditingController(),
    ubicationController: TextEditingController(),
    statusController: TextEditingController(),
    activityController: TextEditingController(),
    observationsController: TextEditingController(),
  );
  final tripOneData = TripData(
    recordController: TextEditingController(),
    registerDateController: TextEditingController(),
    startScheduleController: TextEditingController(),
    finalScheduleController: TextEditingController(),
    totalHoursController: TextEditingController(),
  );

  final tripTwoData = TripData(
    recordController: TextEditingController(),
    registerDateController: TextEditingController(),
    startScheduleController: TextEditingController(),
    finalScheduleController: TextEditingController(),
    totalHoursController: TextEditingController(),
  );
  final workScheduleOne = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
  final workScheduleTwo = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
  final workScheduleThree = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
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
    final PdfGenerator pdfGenerator = PdfGenerator();
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

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
            pw.Text('Datos Generales del Reporte',
                style: pw.Theme.of(context).header3),
            pw.Table(children: [
              pdfGenerator.buildTableRow(
                  'Número de referencia:',
                  customerData.referenceNumberController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Nombre FSE:',
                  customerData.clientNameController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Cliente:',
                  customerData.managerNameController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow('Gerente del Cliente:',
                  customerData.ubicationController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Ubicación:',
                  customerData.statusController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Actividad realizada:',
                  customerData.activityController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Observaciones:',
                  customerData.observationsController.text.toString().trim(),
                  ttf)
            ]),
            pw.Text('Datos del Viaje', style: pw.Theme.of(context).header3),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Registro',
                  tripOneData.recordController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Fecha de Registro',
                  tripOneData.registerDateController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Inicio de Horario',
                  tripOneData.startScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Fin de Horario',
                  tripOneData.finalScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  tripOneData.totalHoursController.text.toString().trim(), ttf)
            ]),
            pw.Divider(),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Registro',
                  tripTwoData.recordController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Fecha de Registro',
                  tripTwoData.registerDateController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Inicio de Horario',
                  tripTwoData.startScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Fin de Horario',
                  tripTwoData.finalScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  tripTwoData.totalHoursController.text.toString().trim(), ttf)
            ]),
            pw.Text('Horarios Registrados',
                style: pw.Theme.of(context).header3),
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

    return generateFile(pdf, customerData.referenceNumberController.text, this);
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(DateTime.now().millisecondsSinceEpoch,
        customerData.referenceNumberController.text, downloadURL, false,
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

  void calculateTimeDifference(TimeOfDay? startTime, TimeOfDay? endTime,
      TextEditingController controller) {
    if (startTime != null && endTime != null) {
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      // Si la hora de fin es menor que la hora de inicio, asumimos que es al día siguiente
      final minutesDifference = endMinutes >= startMinutes
          ? endMinutes - startMinutes
          : (1440 - startMinutes) + endMinutes; // 1440 minutos en un día

      controller.text = '$minutesDifference min';
      notifyListeners();
    }
  }

  bool validateControllers() {
    if (customerData.referenceNumberController.text.trim().isEmpty ||
        customerData.clientNameController.text.trim().isEmpty ||
        customerData.managerNameController.text.trim().isEmpty ||
        customerData.ubicationController.text.trim().isEmpty ||
        customerData.statusController.text.trim().isEmpty ||
        customerData.activityController.text.trim().isEmpty ||
        customerData.observationsController.text.trim().isEmpty ||
        urlController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void clearControllers() {
    customerData.referenceNumberController.clear();
    customerData.clientNameController.clear();
    customerData.managerNameController.clear();
    customerData.ubicationController.clear();
    customerData.statusController.clear();
    customerData.activityController.clear();
    customerData.observationsController.clear();
    urlController.clear();
  }
}
