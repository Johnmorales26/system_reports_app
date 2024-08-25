import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import '../appModule/assets.dart';
import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import 'package:image/image.dart' as img;

class ReportScreen extends StatelessWidget {
  static const String route = '/ReportScreen';

  const ReportScreen({super.key});

  Future<File> _getSignatureFile(ReportViewModel viewModel) async {
    final imageBytes = await viewModel.signatureController.toPngBytes();
    if (imageBytes != null) {
      final image = img.decodeImage(imageBytes)!;
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/signature.png');
      await file.writeAsBytes(img.encodePng(image));
      return file;
    }
    throw Exception('Failed to convert signature to image file');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReportViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    Widget view = Container();
    if (screenWidth >= 600) {
      view = Center(
          child: Row(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.commonPaddingDefault),
                child: SingleChildScrollView(child: _Form())),
          ),
          Expanded(
            child: Lottie.asset(Assets.documentAnim),
          ),
        ],
      ));
    } else {
      view = Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.commonPaddingDefault),
          child: SingleChildScrollView(child: _Form()));
    }

    Widget button = Container();
    if (viewModel.validateControllers()) {
      button = FloatingActionButton(
          onPressed: () async {
            if (kIsWeb) {
              Fluttertoast.showToast(
                  msg: "Esta opción no está disponible en la web.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
                  Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (Route<dynamic> route) => false);
            } else {
              final signature = await _getSignatureFile(viewModel);
              var response = await viewModel.generatePDF(signature);
              if (response) {
                viewModel.clearControllers();
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (route) => false);
              } else {
                Fluttertoast.showToast(
                  msg: 'Error al subir el archivo',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            }
          },
          child: const Icon(Icons.file_open));
    } else {
      button = Container();
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Report'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.route, (Route<dynamic> route) => false),
                icon: const Icon(Icons.arrow_back))),
        body: view,
        floatingActionButton: button);
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportViewModel>(context);

    Widget isSelectedImage = Container();
    if (provider.urlController.text.isEmpty) {
      isSelectedImage = FloatingActionButton.extended(
          onPressed: () async {
            var result = await getImageFromGallery(context, provider);
            provider.updateSelectedImage(result);
          },
          label: const Text('Subir Imagen'),
          icon: const Icon(Icons.add_a_photo_outlined));
    } else {
      _ImagePreview(picture: provider.urlController.text);
    }

    return Column(children: [
      TextField(
          controller: provider.referenceNumberController,
          decoration: const InputDecoration(
            labelText: 'Reference Number',
            hintText: 'Enter your reference number',
            prefixIcon: Icon(Icons.code),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.clientController,
          decoration: const InputDecoration(
            labelText: 'Client',
            hintText: 'Enter your client name',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'Enter your location',
            prefixIcon: Icon(Icons.location_on),
            filled: true,
          ),
          keyboardType: TextInputType.streetAddress),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.nameFSEController,
          decoration: const InputDecoration(
            labelText: 'Name FSE',
            hintText: 'Enter your name FSE',
            prefixIcon: Icon(Icons.person_2),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customManagerController,
          decoration: const InputDecoration(
            labelText: 'Custom Manager',
            hintText: 'Enter your custom manager',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.activityPerformedController,
          decoration: const InputDecoration(
            labelText: 'Activity Performed',
            hintText: 'Enter your activity performed',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.observationsController,
          decoration: const InputDecoration(
            labelText: 'Observations',
            hintText: 'Enter your observations',
            prefixIcon: Icon(Icons.notes),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.urlController,
          decoration: const InputDecoration(
            labelText: 'Url Image',
            enabled: false,
            prefixIcon: Icon(Icons.file_copy_outlined),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      Signature(
        controller: provider.signatureController,
        height: 150,
      ),
      const SizedBox(height: Dimens.commonPaddingMin),
      isSelectedImage
    ]);
  }
}

class _ImagePreview extends StatelessWidget {
  final String picture;

  const _ImagePreview({required this.picture});

  @override
  Widget build(BuildContext context) {
    return Image.network(picture, width: 100, height: 200);
  }
}
