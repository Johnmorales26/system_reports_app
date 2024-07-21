import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import '../appModule/assets.dart';
import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';

class ReportScreen extends StatelessWidget {
  static const String route = '/ReportScreen';

  const ReportScreen({super.key});

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
                padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
                child: SingleChildScrollView(child: _Form())),
          ),
          Expanded(
            child: Lottie.asset(Assets.documentAnim),
          ),
        ],
      ));
    } else {
      view = Padding(
          padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
          child: SingleChildScrollView(child: _Form()));
    }

    Widget button = Container();
    if (viewModel.validateControllers()) {
      button = FloatingActionButton(
          onPressed: () async {
            var response = await viewModel.generatePDF();
            if (response) {
              viewModel.clearControllers();
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: 'Error al subir el archivo',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
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
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.route, (Route<dynamic> route) => false),
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
          decoration: InputDecoration(
              labelText: 'Reference Number',
              hintText: 'Enter your reference number',
              prefixIcon: const Icon(Icons.code),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.clientController,
          decoration: InputDecoration(
              labelText: 'Client',
              hintText: 'Enter your client name',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.locationController,
          decoration: InputDecoration(
              labelText: 'Location',
              hintText: 'Enter your location',
              prefixIcon: const Icon(Icons.location_on),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.streetAddress),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.nameFSEController,
          decoration: InputDecoration(
              labelText: 'Name FSE',
              hintText: 'Enter your name FSE',
              prefixIcon: const Icon(Icons.person_2),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customManagerController,
          decoration: InputDecoration(
              labelText: 'Custom Manager',
              hintText: 'Enter your custom manager',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.activityPerformedController,
          decoration: InputDecoration(
              labelText: 'Activity Performed',
              hintText: 'Enter your activity performed',
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.observationsController,
          decoration: InputDecoration(
              labelText: 'Observations',
              hintText: 'Enter your observations',
              prefixIcon: const Icon(Icons.notes),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.urlController,
          decoration: InputDecoration(
              labelText: 'Url Image',
              enabled: false,
              prefixIcon: const Icon(Icons.file_copy_outlined),
              filled: true,
              fillColor: Colors.grey[200]),
          keyboardType: TextInputType.text),
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
