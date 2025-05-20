import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ukl_paket1/widgets/navbar.dart';
import 'package:ukl_paket1/utils/styles.dart';

import '../services/url.dart' as url;

class MatkulViewPage extends StatefulWidget {
  const MatkulViewPage({super.key});

  @override
  State<MatkulViewPage> createState() => _MatkulViewPageState();
}

class _MatkulViewPageState extends State<MatkulViewPage> {
  List<dynamic> matkulList = [];
  List<bool> selected = [];
  bool isLoading = true;
  String? error;

  Future<void> fetchMatkul() async {
    try {
      final response = await http.get(Uri.parse(url.BaseUrl + '/getmatkul'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          matkulList = data['data'];
          selected = List<bool>.filled(matkulList.length, false);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data mata kuliah");
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMatkul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Daftar Mata Kuliah", style: AppTextStyles.header),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error', style: AppTextStyles.label))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Silakan pilih mata kuliah yang ingin diambil:",
                          style: AppTextStyles.label,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: matkulList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            var matkul = matkulList[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.radius12,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      AppColors.accent.withOpacity(0.2),
                                  child: Text(
                                    matkul['id']?.toString() ?? "-",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  matkul['nama_matkul'] ?? "Tidak diketahui",
                                  style: AppTextStyles.inputText,
                                ),
                                subtitle: Text(
                                  "${matkul['sks'] ?? '-'} SKS",
                                  style: AppTextStyles.label,
                                ),
                                trailing: Checkbox(
                                  value: selected[index],
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  onChanged: (val) {
                                    setState(() {
                                      selected[index] = val!;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            List<Map<String, dynamic>> selectedMatkul = [];

                            for (int i = 0; i < selected.length; i++) {
                              if (selected[i]) {
                                selectedMatkul.add({
                                  "id": matkulList[i]['id'],
                                  "nama_matkul": matkulList[i]['nama_matkul'],
                                  "sks": matkulList[i]['sks'],
                                });
                              }
                            }

                            if (selectedMatkul.isEmpty) {
                              final responseMap = {
                                "status": false,
                                "message": "Tidak ada matkul yang dipilih",
                              };

                              print(const JsonEncoder.withIndent('  ')
                                  .convert(responseMap));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      "Tidak ada mata kuliah yang disimpan"),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            } else {
                              final responseMap = {
                                "status": true,
                                "message": "Matkul selected successfully",
                                "data": {
                                  "list_matkul": selectedMatkul,
                                }
                              };

                              print(const JsonEncoder.withIndent('  ')
                                  .convert(responseMap));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Mata kuliah disimpan"),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.radius12,
                            ),
                          ),
                          child: const Text(
                            "Simpan yang Terpilih",
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomNav(1),
    );
  }
}
