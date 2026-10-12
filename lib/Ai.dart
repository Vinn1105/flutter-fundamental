import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AcademicOverviewApp());

class AcademicOverviewApp extends StatefulWidget {
  const AcademicOverviewApp({super.key});

  @override
  State<AcademicOverviewApp> createState() => _AcademicOverviewAppState();
}

class _AcademicOverviewAppState extends State<AcademicOverviewApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Overview',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: AcademicOverviewPage(
        isDark: isDark,
        onDarkChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class AcademicOverviewPage extends StatelessWidget {
  const AcademicOverviewPage({
    required this.isDark,
    required this.onDarkChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onDarkChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Overview'),
        actions: [
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              const SizedBox(width: 8),
              Semantics(
                label:
                    'Tombol ganti tema ke mode ${isDark ? "terang" : "gelap"}',
                child: CupertinoSwitch(value: isDark, onChanged: onDarkChanged),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      // Menggunakan SingleChildScrollView untuk mencegah overflow vertikal
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Profil Mahasiswa
              const ProfileHeader(),
              const SizedBox(height: 20),

              // 2. LayoutBuilder + Wrap (Rekomendasi AI untuk Responsivitas & Menghindari Grid Scroll Conflict)
              LayoutBuilder(
                builder: (context, constraints) {
                  // Audit responsif: breakpoint di 600px
                  final isWide = constraints.maxWidth >= 600;
                  final double cardWidth = isWide
                      ? (constraints.maxWidth - 16) /
                            2 // 2 kolom di layar lebar
                      : constraints
                            .maxWidth; // 1 kolom penuh di layar sempit (<600px)

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      InfoCard(
                        title: 'IPK Kumulatif',
                        value: '3.82',
                        icon: Icons.school,
                        color: Colors.blue,
                        width: cardWidth,
                      ),
                      InfoCard(
                        title: 'Total SKS Lulus',
                        value: '84 SKS',
                        icon: Icons.menu_book,
                        color: Colors.green,
                        width: cardWidth,
                      ),
                      InfoCard(
                        title: 'Kehadiran',
                        value: '96%',
                        icon: Icons.verified_user,
                        color: Colors.orange,
                        width: cardWidth,
                      ),
                      InfoCard(
                        title: 'Tugas Aktif',
                        value: '3 Tugas',
                        icon: Icons.assignment,
                        color: Colors.purple,
                        width: cardWidth,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Header Profil
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isThemeDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label:
          'Profil Mahasiswa: Alvin, Program Studi Teknik Informatika, Kelas A',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isThemeDark
              ? Colors.indigo.shade900.withOpacity(0.5)
              : Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isThemeDark
                ? Colors.indigo.shade700
                : Colors.indigo.shade200,
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alvin',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teknik Informatika • Kelas A',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Kartu Informasi Akademik
class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.width,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isThemeDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Kartu informasi $title, nilai saat ini $value',
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isThemeDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isThemeDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: isThemeDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: isThemeDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isThemeDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
