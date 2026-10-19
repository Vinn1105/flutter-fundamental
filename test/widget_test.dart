import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/main.dart';
import 'package:pml/widgets/footer_widget.dart';
import 'package:pml/widgets/item_card_widget.dart';

void main() {
  testWidgets('Memverifikasi halaman utama memuat ItemCardWidget dan FooterWidget', (WidgetTester tester) async {
    // Bangun aplikasi dan jalankan 1 frame
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi judul aplikasi muncul di AppBar
    expect(find.text('Katalog Belanja'), findsOneWidget);

    // Verifikasi bahwa widget kartu produk (ItemCardWidget) muncul
    expect(find.byType(ItemCardWidget), findsWidgets);

    // Verifikasi bahwa FooterWidget ada dan menampilkan Nama serta NIM Alvin
    expect(find.byType(FooterWidget), findsOneWidget);
    expect(find.text('Alvin Kurnia Pratama'), findsOneWidget);
    expect(find.text('NIM: 24.52.0006'), findsOneWidget);
  });

  testWidgets('Navigasi ke halaman detail dan verifikasi widget Hero serta data barang', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final firstBarang = listBarang.first;

    // Ketuk item pertama
    await tester.tap(find.text(firstBarang.nama));
    await tester.pumpAndSettle(); // Tunggu animasi transisi Hero dan navigasi GoRouter selesai

    // Verifikasi halaman detail terbuka dengan judul AppBar 'Detail Produk'
    expect(find.text('Detail Produk'), findsOneWidget);

    // Verifikasi data barang ditampilkan di halaman detail
    expect(find.text(firstBarang.nama), findsOneWidget);
    expect(find.text(firstBarang.formattedHarga), findsOneWidget);
    expect(find.textContaining(firstBarang.stok.toString()), findsWidgets);
    expect(find.textContaining(firstBarang.rating.toString()), findsWidgets);

    // Verifikasi keberadaan widget Hero pada halaman detail
    final heroFinder = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'barang-image-${firstBarang.id}',
    );
    expect(heroFinder, findsOneWidget);

    // Navigasi kembali ke halaman utama
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke halaman utama
    expect(find.text('Katalog Belanja'), findsOneWidget);
  });
}
