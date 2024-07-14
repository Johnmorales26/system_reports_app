import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? selectedImage;
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
    return await uploadFile(file);
  }

  Future<String> getInternalStoragePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> uploadFile(File file) async {
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

  Future<void> uploadImage(File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        _uploadProgress = progress;
        print('Proceso de subida de PDF: $_uploadProgress');
        notifyListeners();
      });

      await uploadTask.whenComplete(() async {
        selectedImage = await storageRef.getDownloadURL();
        print('Archivo subido! URL de descarga: $selectedImage');
        notifyListeners();
      });
    } catch (e) {
      print('Error al subir archivo: $e');
      // Puedes agregar más detalles sobre el error específico aquí, dependiendo de tus necesidades.
    }
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(DateTime.now().millisecondsSinceEpoch,
        referenceNumberController.text, downloadURL, false,
        image: selectedImage!);
    return firebaseDatabase.createTask(taskEntity);
  }

  Future<void> getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      uploadImage(File(pickedFile!.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
          const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}
