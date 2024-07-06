import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class ReportScreen extends StatelessWidget {

  static const String route = '/ReportScreen';

  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReportViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
        child: SingleChildScrollView(child: _Form())
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => viewModel.generatePDF(), child: const Icon(Icons.file_open))
    );
  }
}

class _Form extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportViewModel>(context);
    return Column(
      children: [
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
      ]
    );
  }
}