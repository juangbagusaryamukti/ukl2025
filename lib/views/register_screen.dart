import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ukl_paket1/views/login_screen.dart';
import 'package:ukl_paket1/utils/styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  String gender = "Laki-laki";
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  XFile? _pickedFile;
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _pickedFile = pickedFile;
        });
      } else {
        setState(() {
          _pickedFile = pickedFile;
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    var uri = Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl1/api/register');
    var request = http.MultipartRequest('POST', uri);

    request.fields['nama_nasabah'] = namaController.text;
    request.fields['gender'] = gender;
    request.fields['alamat'] = alamatController.text;
    request.fields['telepon'] = teleponController.text;
    request.fields['username'] = usernameController.text;
    request.fields['password'] = passwordController.text;

    if (_pickedFile != null) {
      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'foto',
          await _pickedFile!.readAsBytes(),
          filename: _pickedFile!.name,
        ));
      } else {
        request.files
            .add(await http.MultipartFile.fromPath('foto', _pickedFile!.path));
      }
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var data = jsonDecode(respStr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Berhasil Register',
              style: AppTextStyles.snackBar),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Gagal Register: $respStr', style: AppTextStyles.snackBar),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imagePreview;
    if (_imageBytes != null) {
      imagePreview = ClipRRect(
        borderRadius: AppRadius.radius12,
        child: Image.memory(_imageBytes!, height: 120, fit: BoxFit.cover),
      );
    } else if (_pickedFile != null && !kIsWeb) {
      imagePreview = ClipRRect(
        borderRadius: AppRadius.radius12,
        child:
            Image.file(File(_pickedFile!.path), height: 120, fit: BoxFit.cover),
      );
    } else {
      imagePreview = Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: AppRadius.radius12,
        ),
        child: const Center(
          child: Text('Belum pilih foto', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.radius20,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  Text('REGISTER',
                      style: AppTextStyles.header, textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Nasabah',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.person, color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.wc, color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    items: const [
                      DropdownMenuItem(
                          value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(
                          value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) => setState(() => gender = value!),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.home, color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: teleponController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telepon',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.phone, color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  imagePreview,
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Pilih Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.radius12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.account_circle,
                          color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radius12,
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.lock, color: AppColors.primary),
                    ),
                    style: AppTextStyles.inputText,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Wajib diisi';
                      if (value.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.radius20),
                    ),
                    child: const Text('Register', style: AppTextStyles.button),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      'Sudah punya akun? Login',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
