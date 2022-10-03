import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/helper/pdf_invoice_api.dart';
import 'package:shop_app/size_config.dart';
import 'package:printing/printing.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../helper/file_handle_api.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text(
                "PDF Report Generator",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please select pdf report, fill the form and click on generate button",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  convertPdfToImage(File pdf) async {
    final pages = await PdfDocument.openFile(pdf.path);
    final page = await pages.getPage(1);
    final image = await page.render(width: 1500, height: 1500);
    return image;
  }

  saveImageToPhone(PdfPageImage image) async {
    final path = await FilePicker.platform.getDirectoryPath();
    final file = File('$path/image.png');
    await file.writeAsBytes(image.bytes);
  }


  File? pdffile;
  List<String> errors = [];
  String? email;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(30)),
        if (pdffile != null)
          Text(
            'Selected File: ${pdffile!.path.split('/').last}',
          ),
        SizedBox(height: SizeConfig.screenHeight * 0.01),
        DefaultButton(
          text: "Select PDF",
          press: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null) {
              final path = result.files.single.path;
              setState(() {
                pdffile = File(path!);
              });
              PdfPageImage image = await convertPdfToImage(pdffile!);
              PermissionStatus permissions = await Permission.storage.request();
              if (permissions.isGranted) {
                final pdfFile = await PdfInvoiceApi.generate(image);
                FileHandleApi.openFile(pdfFile);
                var uuid = Uuid();
                String randomid = uuid.v1();
                UploadTask uploadTask;
                String saveName = "report_" + randomid;
                final pathToInvoice = 'reports/$saveName';
                final ref = FirebaseStorage.instance.ref().child(pathToInvoice);
                uploadTask = ref.putFile(pdfFile);

                final snapshot = await uploadTask.whenComplete(() => {});
                final urlDownload = await snapshot.ref.getDownloadURL();
                print(urlDownload);
              } else {
                print("Permission denied");
              }
            }
          },
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.1),
      ],
    );
  }
}
