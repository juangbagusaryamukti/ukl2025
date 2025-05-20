import 'package:flutter/material.dart';
import 'package:ukl_paket1/services/profil_service.dart';
import 'package:ukl_paket1/utils/styles.dart';
import 'package:ukl_paket1/views/dasboard_screen.dart';

class UpdateProfilView extends StatefulWidget {
  const UpdateProfilView({super.key});

  @override
  State<UpdateProfilView> createState() => _UpdateProfilViewState();
}

class _UpdateProfilViewState extends State<UpdateProfilView> {
  final formKey = GlobalKey<FormState>();
  final ProfilService profilService = ProfilService();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  String selectedGender = 'Laki-laki';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfil();
  }

  Future<void> loadProfil() async {
    var profil = await profilService.getProfil();
    if (profil != null) {
      setState(() {
        namaController.text = profil.namaPelanggan;
        alamatController.text = profil.alamat;
        teleponController.text = profil.telepon;
        selectedGender = profil.gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Update Profil", style: AppTextStyles.header),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardView()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.radius20,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle,
                      size: 100, color: AppColors.textSecondary),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: namaController,
                    label: "Nama Pelanggan",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: alamatController,
                    label: "Alamat",
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: _inputDecoration("Gender"),
                    style: AppTextStyles.inputText,
                    items: ['Laki-laki', 'Perempuan']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, style: AppTextStyles.inputText),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: teleponController,
                    label: "Telepon",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "UPDATE PROFIL",
                              style: AppTextStyles.button,
                            ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.inputText,
      decoration: _inputDecoration(label),
      validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.label,
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      var data = {
        "nama_pelanggan": namaController.text,
        "alamat": alamatController.text,
        "gender": selectedGender,
        "telepon": teleponController.text,
      };

      bool result = await profilService.updateProfil(data);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result ? "Berhasil update profil" : "Gagal update profil",
            style: AppTextStyles.snackBar,
          ),
          backgroundColor: result ? AppColors.primary : AppColors.error,
        ),
      );
    }
  }
}
