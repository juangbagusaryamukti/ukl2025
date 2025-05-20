import 'package:flutter/material.dart';
import 'package:ukl_paket1/models/nasabahlogin.dart';
import 'package:ukl_paket1/views/login_screen.dart';
import 'package:ukl_paket1/views/update_profile_screen.dart';
import 'package:ukl_paket1/widgets/navbar.dart';
import 'package:ukl_paket1/utils/styles.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Nasabahlogin userLogin = Nasabahlogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text("Dashboard", style: AppTextStyles.button),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateProfilView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Datang,",
              style: AppTextStyles.label,
            ),
            const SizedBox(height: 4),
            Text(
              userLogin.username ?? "User",
              style: AppTextStyles.header,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.radius20,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.radius20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Akun",
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem("Saldo", "Rp 0"),
                        _buildInfoItem("Poin", "0"),
                        _buildInfoItem("Status", "Aktif"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.header.copyWith(
            fontSize: 18,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.label.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
