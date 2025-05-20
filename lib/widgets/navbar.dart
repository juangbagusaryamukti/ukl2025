import 'package:flutter/material.dart';
import 'package:ukl_paket1/utils/styles.dart';
import 'package:ukl_paket1/views/dasboard_screen.dart';
import 'package:ukl_paket1/views/matkul_screen.dart';

class BottomNav extends StatelessWidget {
  final int activePage;

  const BottomNav(this.activePage, {super.key});

  void getLink(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MatkulViewPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activePage,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: Colors.white,
      selectedLabelStyle: AppTextStyles.label.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary,
      ),
      onTap: (index) => getLink(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Mata Kuliah',
        ),
      ],
    );
  }
}
