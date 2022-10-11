import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/helper/pdf_invoice_api.dart';
import 'package:shop_app/size_config.dart';
import 'package:pdfx/pdfx.dart';
import 'package:uuid/uuid.dart';
import '../../../constants.dart';

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
              SizedBox(height: SizeConfig.screenHeight * 0.02),
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

  dynamic pdffile;
  List<String> errors = [];
  String? email;
  String? urlDownload;
  TextEditingController _patientEmailController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _protocolNoController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _applicationAreaController = TextEditingController();
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyTextSelectPdf = ButtonState.idle;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _patientEmailController,
            decoration: InputDecoration(
              hintText: "Hasta Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            controller: _patientNameController,
            decoration: InputDecoration(
              hintText: "Hasta Adı ve Soyadı",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            controller: _protocolNoController,
            decoration: InputDecoration(
              hintText: "Protocol No",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: "Tarih",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            controller: _applicationAreaController,
            decoration: InputDecoration(
              hintText: "Uygulama Alanı ve CC",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          if (pdffile != null)
            Text(
              'Selected File: ${pdffile!.path.split('/').last}',
            ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: selectPdfButton(),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              Expanded(
                child: generatePdfButton(),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }

  sendEmail(List<String> sendEmailTo, String subject, String emailBody,
      String path) async {
    await FirebaseFirestore.instance.collection("mail").add({
      'to': sendEmailTo,
      'message': {
        'subject': '$subject',
        'text': '$emailBody',
        'html':
            '<html>Your report has been generated! You can find your report attached:</html>',
        'attachments': [
          {
            'path': '$path',
            'type': 'pdf',
            'name': 'Report',
            'filename': "Report.pdf",
          }
        ]
      },
    }).then(
      (value) => {print("Queued email for delivery!")},
    );
  }

  Widget generatePdfButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "PDF Oluştur",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Oluşturuluyor",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Hata",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Oluşturuldu",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: kPrimaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.grey.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.red),
        strokeWidth: 1,
      ),
      onPressed: () async {
        setState(() {
          stateOnlyText = ButtonState.loading;
        });
        String findUser = await findUseridByEmail(_patientEmailController.text);
        if (findUser != 'null') {
          if (pdffile != null) {
            PdfPageImage image = await convertPdfToImage(pdffile!);

            var uuid = Uuid();
            String randomid = uuid.v1();
            final pdfFile = await PdfInvoiceApi.generate(
                image,
                _patientNameController.text,
                _protocolNoController.text,
                _dateController.text,
                _applicationAreaController.text,
                randomid);
            //FileHandleApi.openFile(pdfFile);
            UploadTask uploadTask;
            String saveName = "report_" + randomid;
            final pathToReport = 'reports/$saveName';
            final ref = FirebaseStorage.instance.ref().child(pathToReport);
            uploadTask = ref.putData(pdfFile);

            final snapshot = await uploadTask.whenComplete(() => {});
            urlDownload = await snapshot.ref.getDownloadURL();
            addReportToUser(randomid, findUser);
            addReportToDB(randomid, urlDownload!, findUser);
            await sendEmail(['${_patientEmailController.text}'],
                "Report Generated", "Report Data", urlDownload!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                '⚠️ Please select a PDF file.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: kPrimaryColor,
              behavior: SnackBarBehavior.floating,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              '⚠️ Bu emailde bir kullanıcı bulunamadı.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: kPrimaryColor,
            behavior: SnackBarBehavior.floating,
          ));
        }

        if (urlDownload != null) {
          setState(() {
            stateOnlyText = ButtonState.success;
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
          pdffile = null;
          urlDownload = null;
        } else {
          setState(() {
            stateOnlyText = ButtonState.fail;
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        }
      },
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  Widget selectPdfButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "PDF Seç",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Seçiliyor",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Yeniden Dene",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Oluşturulmaya Hazır",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: kPrimaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: kRedColor,
        ButtonState.success: kGreenColor,
      },
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.red),
        strokeWidth: 1,
      ),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          final path = result.files.single.path;
          setState(() {
            pdffile = File(path!);
            stateOnlyTextSelectPdf = ButtonState.success;
          });
        }
      },
      state: stateOnlyTextSelectPdf,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }
}
