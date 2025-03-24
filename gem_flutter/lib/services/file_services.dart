import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:gem_flutter/models/article.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

/// This class provides services related to file operations such as downloading
/// Excel templates, uploading Excel files, fetching and downloading analysis results.
class FileServices {
  /// Method to download the Excel template.
  /// It creates an Excel file with predefined headers and example data,
  /// then saves it using the FileSaver instance.
  Future<void> downloadExcelTemplate() async {
    try {
      // Create a new Excel document
      var excel = Excel.createExcel();

      // Add a sheet
      Sheet sheetObject = excel['Sheet1'];

      // Add headers
      sheetObject.insertRowIterables(ExcelTemplate.headers, 0);

      // Add example data
      sheetObject.insertRowIterables(ExcelTemplate.data, 1);

      // Convert to bytes
      var excelBytes = excel.encode()!;

      // Save the file using FileSaver
      await FileSaver.instance.saveFile(
        name: 'template',
        bytes: Uint8List.fromList(excelBytes),
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    } catch (e) {
      throw Exception("${GlobalVariables.downloadingFileErrorMessage} $e");
    }
  }

  /// Method to upload an Excel file from the user's computer.
  /// It reads the Excel file, extracts article data, and returns a list of Article objects.
  Future<List<Article>> uploadExcel() async {
    try {
      // Pick a file using FilePicker
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (pickedFile != null) {
        PlatformFile file = pickedFile.files.single;
        if (file.bytes != null) {
          // Read the Excel file
          var bytes = file.bytes;
          var excel = Excel.decodeBytes(bytes as List<int>);

          // Extract article data
          List<Article> articles = [];
          // Browse excel sheets
          for (var table in excel.tables.keys) {
            // retrieve the contents of each sheet
            var sheet = excel.tables[table];
            // check that the sheet is not null and that it has lines
            if (sheet != null && sheet.rows.isNotEmpty) {
              // scroll through the rows of the sheet, starting with the second one
              for (var i = 1; i < sheet.rows.length; i++) {
                // Recover line data
                var row = sheet.rows[i];
                // Check that the necessary columns are present
                if (row.length >= 8) {
                  // Article creation, ensuring that values are not zero
                  try {
                    articles.add(Article(
                      no: int.parse(row[0]!.value.toString()),
                      semaine: int.parse(row[1]!.value.toString()),
                      media: int.parse(row[2]!.value.toString()),
                      articleRepris: int.parse(row[3]!.value.toString()),
                      url: row[4]!.value.toString(),
                      title: row[5]!.value.toString(),
                      chapo: row[6]!.value.toString(),
                      content: row[7]!.value.toString(),
                    ));
                  } catch (e) {
                    throw Exception(
                        "${GlobalVariables.lineHasNullValueErrorMessage} $i");
                  }
                } else {
                  throw Exception(
                      "${GlobalVariables.lineDoesntHaveRequiredColumnsErrorMessage} $i");
                }
              }
            } else {
              throw Exception(
                  "${GlobalVariables.sheetIsEmptyOrNullErrorMessage} $table");
            }
          }
          return articles;
        } else {
          throw Exception(GlobalVariables.noFileContentErrorMessage);
        }
      } else {
        throw Exception(GlobalVariables.noFileSelectedMessage);
      }
    } catch (e) {
      throw Exception("${GlobalVariables.downloadingFileErrorMessage} $e");
    }
  }

  /// Method to download analysis results.
  /// It sends a request to download the file and saves it using the FileSaver instance.
  Future<void> downloadAnalysisResults(String fileName) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.apiUrlDownloadResults),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'file_name': fileName}),
      );
      if (response.statusCode == 200) {
        // Save the file using FileSaver
        await FileSaver.instance.saveFile(
          name: fileName.substring(0, fileName.length - 4),
          bytes: response.bodyBytes,
          ext: "csv",
          mimeType: MimeType.csv,
        );
      } else if (response.statusCode == 404) {
        throw Exception(
            '${GlobalVariables.fileNotFoundErrorMessage} ${response.statusCode}');
      } else if (response.statusCode == 500) {
        throw Exception(
            '${GlobalVariables.serverErrorMessage} ${response.statusCode}');
      } else {
        throw Exception(
            '${GlobalVariables.unexpectedErrorMessage} ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('${GlobalVariables.downloadingFileErrorMessage}: $e');
    }
  }

  /// Fetches the analysis results from the server.
  Future<List<List<dynamic>>> fetchAnalysisResults(String fileName) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.apiUrlDownloadResults),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'file_name': fileName}),
      );
      if (response.statusCode == 200) {
        final csvData = response.body;
        return const CsvToListConverter().convert(csvData);
      } else if (response.statusCode == 404) {
        throw Exception(
            '${GlobalVariables.fileNotFoundErrorMessage} ${response.statusCode}');
      } else if (response.statusCode == 500) {
        throw Exception(
            '${GlobalVariables.serverErrorMessage} ${response.statusCode}');
      } else {
        throw Exception(
            '${GlobalVariables.unexpectedErrorMessage} ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('${GlobalVariables.fetchingDataErrorMessage} $e');
    }
  }
}
