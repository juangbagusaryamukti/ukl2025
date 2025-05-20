import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static Future<Map<String, dynamic>> registerUser({
    required String nama,
    required String gender,
    required String alamat,
    required String telepon,
    required String username,
    required String password,
    XFile? foto,
  }) async {
    var uri = Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl1/api/register');
    var request = http.MultipartRequest('POST', uri);

    request.fields['nama_nasabah'] = nama;
    request.fields['gender'] = gender;
    request.fields['alamat'] = alamat;
    request.fields['telepon'] = telepon;
    request.fields['username'] = username;
    request.fields['password'] = password;

    if (foto != null) {
      if (kIsWeb) {
        final bytes = await foto.readAsBytes();
        request.files.add(
            http.MultipartFile.fromBytes('foto', bytes, filename: foto.name));
      } else {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(respStr);
    } else {
      throw Exception('Gagal Register: $respStr');
    }
  }
}
