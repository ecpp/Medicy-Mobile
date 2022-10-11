import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shop_app/models/Transaction.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<Uint8List> generate(PdfPageImage image, String name, String protocolNo, String date, String area, String documentID) async {
    final pdf = pw.Document();

    final tableHeaders = [
      'HASTA ADI SOYADI',
      'PROTOKOL NO',
      'TARIH',
      'UYGULAMA ALANI VE CC',
    ];

    final tableData = [[]];


    final row = [
      name,
      protocolNo,
      date,
      area,
    ];
    tableData.add(row);



    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'STEMBIO KÖK HÜCRE TEKNOLJILERI A.S.',
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'HASTA UYGULAMA RAPORU',
                      style: const pw.TextStyle(
                        fontSize: 15.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
              },
            ),
            pw.Divider(),
            pw.Image(pw.MemoryImage(image.bytes)),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'STEMBIO APP',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Adres: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  ),
                  pw.Text('TUBITAK MARMARA TEKNOKENT AR-GE VE INOVASYON MERKEZI, Kosuyolu Cd. No:26/10, 41400 Gebze/Kocaeli', style: pw.TextStyle(fontSize: 8)),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Email: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  ),
                  pw.Text(
                    'info@stembio.com.tr', style: pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    // pdf.addPage(pw.Page(build: (pw.Context context) {
    //   return pw.Center(
    //     child: pw.Image(pw.MemoryImage(image.bytes), fit: pw.BoxFit.fill),
    //   ); // Center
    // }));
    // final file = File("example.pdf");
    // await file.writeAsBytes(await pdf.save());
    final bytes = await pdf.save();
    return bytes;


  }
}
