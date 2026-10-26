# LAPORAN PRAKTIKUM 5: NAVIGASI DAN RUTE DI FLUTTER

**Identitas Mahasiswa:**
- **Nama:** Alvin Kurnia Pratama
- **NIM:** 24.52.0006
- **Mata Kuliah:** Pemrograman Mobile
- **Repository GitHub:** [https://github.com/Vinn1105/flutter-fundamental.git](https://github.com/Vinn1105/flutter-fundamental.git)

---

## BAB 1: PRAKTIKUM 1 (RUTE DASAR NAVIGATOR)

Pada Praktikum 1, dipelajari konsep dasar navigasi dan perpindahan halaman (*route transition*) di Flutter menggunakan sistem `Navigator` imperatif bawaan (Navigator 1.0) dengan named routes (`routes` table pada `MaterialApp`). Selain itu, dilakukan refaktorisasi antarmuka katalog dari daftar linear menjadi tata letak grid dua kolom, penyematan animasi `Hero`, serta modularisasi komponen antarmuka termasuk pembuatan *widget* Footer identitas.

### 1.1 Penjelasan Alur Kode & Implementasi

#### 1. Pengiriman & Pembacaan Data
Pada rute dasar `Navigator`, tabel rute didaftarkan terlebih dahulu di berkas `lib/main.dart` melalui properti `routes` dan `initialRoute`:

```dart
// lib/main.dart (Konfigurasi rute dasar Navigator)
MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => const ShopingScreen(),
    '/detail': (context) => const DetailShopingScreen(),
  },
);
```

Untuk berpindah halaman sekaligus mengirimkan data objek model `Barang` ke halaman tujuan, digunakan metode `Navigator.pushNamed` dengan menyertakan parameter `arguments`. Potongan kode berikut diambil dari implementasi awal pada `lib/widgets/item_barang_widget.dart`:

```dart
// lib/widgets/item_barang_widget.dart (Pengiriman data objek Barang)
GestureDetector(
  onTap: () {
    Navigator.pushNamed(
      context, 
      '/detail', 
      arguments: barang,
    );
  },
  child: Container(
    color: Colors.tealAccent,
    margin: const EdgeInsets.symmetric(vertical: 3),
    padding: const EdgeInsets.all(5),
    child: Text(barang.nama_barang),
  ),
);
```

Pada halaman tujuan (`DetailShopingScreen`), data objek yang dikirim melalui `arguments` diekstraksi menggunakan `ModalRoute.of(context)!.settings.arguments`. Nilai tersebut kemudian di-*cast* ke tipe model `Barang`:

```dart
// lib/pages/detail_shoping_screen.dart (Penerimaan data via ModalRoute)
@override
Widget build(BuildContext context) {
  final barang = ModalRoute.of(context)!.settings.arguments as Barang;

  return Scaffold(
    appBar: AppBar(
      title: const Text("Detail Shopping"),
      backgroundColor: Colors.blue,
    ),
    body: Container(
      padding: const EdgeInsets.all(20),
      child: Text(barang.nama_barang),
    ),
  );
}
```

> **Alur Eksekusi:**
> 1. Pengguna mengetuk salah satu kartu produk di halaman belanja (`ShopingScreen`).
> 2. `Navigator.pushNamed` menambahkan rute `'/detail'` ke atas *navigation stack* dengan membawa *payload* objek `barang`.
> 3. `DetailShopingScreen` membaca *argument* tersebut melalui `ModalRoute` dan merender detail informasi barang yang dipilih.

> [Tempelkan Screenshot Tampilan di Sini: Pengujian Navigasi Navigator.pushNamed dan Penerimaan Data di Halaman Detail]

---

#### 2. Tampilan GridView
Pada rancangan antarmuka tahap awal, daftar produk disajikan secara linier vertikal menggunakan `ListView.builder`. Agar tampilan menyerupai aplikasi *e-commerce / marketplace* modern, struktur tersebut diubah menjadi `GridView.builder` dengan konfigurasi dua kolom.

Implementasi ini terletak pada berkas `lib/pages/shoping_screen.dart`:

```dart
// lib/pages/shoping_screen.dart (Layout GridView 2 Kolom)
Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: listBarang.length,
      // Mengatur layout Grid menjadi 2 kolom ala marketplace
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,         // Menentukan 2 kolom horizontal
        childAspectRatio: 0.72,    // Rasio proporsional lebar terhadap tinggi kartu
        crossAxisSpacing: 10,      // Jarak horizontal antar kartu
        mainAxisSpacing: 10,       // Jarak vertikal antar kartu
      ),
      itemBuilder: (context, index) {
        final barang = listBarang[index];
        // Memanggil widget kartu modular
        return ItemCardWidget(barang: barang);
      },
    ),
  ),
),
```

> **Penjelasan Teknis:**
> - `crossAxisCount: 2` membagi lebar layar secara seimbang menjadi dua kolom kartu produk.
> - `childAspectRatio: 0.72` memberikan ruang vertikal yang cukup untuk memuat foto produk, badge *rating*, nama produk, harga berformat Rupiah, dan indikator ketersediaan stok tanpa menyebabkan *render overflow*.
> - `BouncingScrollPhysics()` memberikan efek pantulan elastis saat daftar mencapai batas atas atau bawah.

> [Tempelkan Screenshot Tampilan di Sini: Tampilan GridView 2 Kolom Katalog Belanja]

---

#### 3. Animasi Hero
Widget `Hero` digunakan untuk menyajikan transisi visual yang halus (*shared element transition*) saat pengguna berpindah dari halaman katalog ke halaman rincian produk. Elemen gambar produk seolah-olah terbang dan membesar dari posisi di kartu grid menuju ke *header* halaman detail.

Syarat utama animasi `Hero` adalah kesamaan nilai `tag` pada *route* asal dan *route* tujuan. Di proyek ini, tag dibuat unik per produk menggunakan format string `'barang-image-${barang.id}'`.

**Implementasi pada Halaman Asal (`lib/widgets/item_card_widget.dart`):**
```dart
// lib/widgets/item_card_widget.dart (Hero Widget pada Kartu Grid)
Positioned.fill(
  child: Hero(
    tag: 'barang-image-${barang.id}',
    child: ProductImageWidget(
      imagePath: barang.foto,
      fit: BoxFit.cover,
    ),
  ),
),
```

**Implementasi pada Halaman Tujuan (`lib/pages/detail_shoping_screen.dart`):**
```dart
// lib/pages/detail_shoping_screen.dart (Hero Widget pada Halaman Detail)
Hero(
  tag: 'barang-image-${item.id}',
  child: ProductImageWidget(
    imagePath: item.foto,
    height: 300,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
),
```

> **Alur Animasi:**
> 1. Ketika item pada grid ditekan, Flutter mendeteksi adanya widget `Hero` dengan tag `'barang-image-${id}'` pada halaman asal dan halaman tujuan.
> 2. Selama animasi transisi navigasi berlangsung, Flutter memindahkan widget gambar ke lapisan *overlay* dan menganimasikan ukuran (*rect*) serta posisinya secara mulus hingga mencapai ukuran penuh (tinggi 300 dp) pada halaman detail.

> [Tempelkan Screenshot Tampilan di Sini: Bukti Animasi Transisi Hero Gambar Produk dari Grid ke Detail]

---

#### 4. Modularisasi Widget & Footer
Untuk menjaga keterbacaan kode (*code maintainability*) dan menerapkan prinsip *Separation of Concerns*, komponen antarmuka dipisahkan ke dalam direktori khusus `lib/widgets/`:
1. `footer_widget.dart`: Menampilkan informasi identitas pengembang/mahasiswa.
2. `item_card_widget.dart`: Menangani representasi visual satu kartu produk marketplace.
3. `product_image_widget.dart`: Menangani pemuatan gambar produk baik dari *network URL* maupun *local assets* secara aman dengan indikator *loading* dan *error fallback*.
4. `item_barang_widget.dart`: Bertindak sebagai *bridge/adapter* kompatibilitas kode praktikum lama.

Berikut adalah implementasi `FooterWidget` pada `lib/widgets/footer_widget.dart` yang memuat Nama dan NIM mahasiswa:

```dart
// lib/widgets/footer_widget.dart
import 'package:flutter/material.dart';

/// Widget footer untuk menampilkan identitas mahasiswa (Nama & NIM)
/// di bagian bawah halaman utama aplikasi.
class FooterWidget extends StatelessWidget {
  final String nama;
  final String nim;

  const FooterWidget({
    super.key,
    this.nama = 'Alvin Kurnia Pratama',
    this.nim = '24.52.0006',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.badge_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'NIM: $nim',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

Penyematan `FooterWidget` di halaman utama `lib/pages/shoping_screen.dart` diletakkan di dalam `Column` setelah `Expanded` GridView:

```dart
// lib/pages/shoping_screen.dart (Pemasangan Footer)
body: SafeArea(
  child: Column(
    children: [
      Expanded(child: ... GridView.builder ...),
      // Footer identitas mahasiswa di bagian paling bawah
      const FooterWidget(),
    ],
  ),
),
```

> [Tempelkan Screenshot Tampilan di Sini: Tampilan Footer Widget dengan Nama 'Alvin Kurnia Pratama' dan NIM '24.52.0006']

---

## BAB 2: PRAKTIKUM 2 (INTEGRASI GOROUTER)

Pada Praktikum 2, sistem navigasi ditingkatkan menggunakan paket `go_router` (versi `^18.1.0`). `GoRouter` merupakan solusi routing deklaratif resmi yang menyederhanakan konfigurasi rute bersarang (*nested routes*), parameter URL (*path parameters* dan *query parameters*), serta penanganan riwayat navigasi (*deep linking*) yang sangat esensial untuk aplikasi multiplatform (Mobile dan Web).

### 2.1 Penjelasan Alur Kode & Implementasi

#### 1. Konfigurasi GoRouter
Konfigurasi `GoRouter` didefinisikan secara terpusat pada berkas `lib/main.dart`. Rute utama terdaftar pada path `'/'` dan sub-rute rincian produk didaftarkan pada `'detail/:id'`:

```dart
// lib/main.dart (Konfigurasi deklaratif GoRouter)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/domain/barang.dart';
import 'package:pml/pages/shoping_screen.dart';
import 'package:pml/pages/detail_shoping_screen.dart';

void main() {
  runApp(const MyApp());
}

// Konfigurasi GoRouter untuk navigasi aplikasi
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, _) => const ShopingScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id', // Sub-route dengan path parameter dinamis
          builder: (context, state) => DetailShopingScreen(
            id: state.pathParameters['id'],
            barang: state.extra as Barang?,
          ),
        ),
      ],
    ),
  ],
);
```

Untuk mengaktifkan `GoRouter`, konstruktor aplikasi diganti dari `MaterialApp` standar menjadi `MaterialApp.router` dengan menyuplai instans `_router` ke properti `routerConfig`:

```dart
// lib/main.dart (Inisialisasi MaterialApp.router)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // Menghubungkan konfigurasi router
      title: 'Aplikasi Katalog Belanja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal.shade700,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
    );
  }
}
```

> **Keunggulan Konfigurasi:**
> - Penggunaan sub-rute `'detail/:id'` secara hierarkis menegaskan relasi bahwa halaman detail berada di bawah naungan halaman utama.
> - Sintaks path parameter `:id` memungkinkan aplikasi mendukung skenario *deep linking* langsung menuju produk tertentu via URL (misalnya: `myapp://katalog/detail/2`).

> [Tempelkan Screenshot Tampilan di Sini: Konfigurasi GoRouter di dalam file main.dart]

---

#### 2. Navigasi Berbasis Router
Perpindahan halaman pada `go_router` dapat dipicu menggunakan metode ekstensi `context.go()` atau `context.push()`. Pada aplikasi ini, pengiriman data dilakukan secara komprehensif melalui dua jalur sekaligus:
1. **Path Parameter (`:id`):** Mengirimkan identifier numerik produk di dalam rute URL (`/detail/${barang.id}`).
2. **Extra Parameter (`extra`):** Mengirimkan objek utuh `Barang` tanpa perlu melakukan serialisasi ulang.

Implementasi pemicu navigasi pada `lib/widgets/item_card_widget.dart`:

```dart
// lib/widgets/item_card_widget.dart (Trigger navigasi context.go)
InkWell(
  onTap: () {
    try {
      // Navigasi deklaratif menggunakan GoRouter
      context.go('/detail/${barang.id}', extra: barang);
    } catch (_) {
      // Fallback kompatibilitas jika berjalan pada konteks Navigator standar
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: barang,
      );
    }
  },
  child: ...
)
```

Pada sisi penerima (`lib/pages/detail_shoping_screen.dart`), data diekstrak secara adaptif. Jika objek `barang` tersedia langsung dari argumen `extra`, objek tersebut langsung digunakan; jika tidak, sistem akan mencari data dari daftar produk berdasarkan `id` path parameter, atau *fallback* ke `ModalRoute`:

```dart
// lib/pages/detail_shoping_screen.dart (Penerimaan adaptif data barang)
class DetailShopingScreen extends StatelessWidget {
  final String? id;
  final Barang? barang;

  const DetailShopingScreen({
    super.key,
    this.id,
    this.barang,
  });

  @override
  Widget build(BuildContext context) {
    final Barang item = barang ??
        (id != null
            ? listBarang.firstWhere(
                (b) => b.id.toString() == id,
                orElse: () => listBarang.first,
              )
            : (ModalRoute.of(context)?.settings.arguments as Barang? ?? listBarang.first));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/');
            }
          },
        ),
        ...
      ),
      ...
    );
  }
}
```

> **Catatan Alur Kembali (*Back Navigation*):**
> Pada `BackButton`, disiapkan pengecekan `Navigator.canPop(context)`. Jika rute dibuka via tumpukan normal, maka dipanggil `Navigator.pop(context)`. Apabila rute dibuka langsung via deep-link (tanpa riwayat tumpukan sebelumnya), router akan mengeksekusi `context.go('/')` sehingga pengguna tetap kembali dengan aman ke beranda katalog.

> [Tempelkan Screenshot Tampilan di Sini: Navigasi Halaman Detail dengan Data Produk yang Terisi Sempurna]

---

#### 3. Kompatibilitas UI
Meskipun paradigma navigasi beralih dari imperatif (`Navigator 1.0`) ke deklaratif (`GoRouter`), seluruh komponen antarmuka yang telah dibangun tetap kompatibel dan berjalan tanpa konflik:
- **`GridView.builder`:** Tetap bertindak murni sebagai pengatur tata letak tampilan responsif di `ShopingScreen`, tanpa keterikatan erat (*loose coupling*) terhadap mesin navigasi.
- **`Hero Widget`:** Tetap berfungsi mulus karena `GoRouter` tetap memanfaatkan *underlying route transitions* dari Flutter Engine. Tag `'barang-image-${barang.id}'` terikat secara presisi antara gambar di kartu grid dan gambar utama di halaman detail.
- **`FooterWidget`:** Tetap berada pada posisinya di bagian dasar layar dengan status visual yang statis, tidak bergeser atau berkedip ketika transisi halaman terjadi.
- **Arsitektur Dual-Compatibility:** Adanya mekanisme pertahanan ganda (*fallback*) di `item_card_widget.dart` dan `detail_shoping_screen.dart` menjamin bahwa kode dapat dijalankan baik dalam pengujian otomatis *widget test* maupun saat dijalankan di aplikasi nyata.

> [Tempelkan Screenshot Tampilan di Sini: Tampilan Keseluruhan UI Aplikasi yang Berjalan Lancar dengan GoRouter]

---

## BAB 3: KESIMPULAN

Berdasarkan praktikum yang telah dilakukan, dapat ditarik beberapa poin kesimpulan penting:

### 1. Perbandingan Navigator Bawaan vs GoRouter
| Aspek | Navigator Bawaan (1.0) | GoRouter (Deklaratif) |
| :--- | :--- | :--- |
| **Paradigma** | Imperatif (push & pop manual pada route stack). | Deklaratif berbasis state URL dan konfigurasi terpusat. |
| **Definisi Rute** | Terbatas pada pemetaan string statis di tabel `routes: {}`. | Mendukung pola bersarang (*nested routes*), path parameters (`:id`), dan regex. |
| **Passing Data** | Menggunakan `arguments: dynamic` yang dibaca lewat `ModalRoute`. | Menggunakan `pathParameters`, `queryParameters`, serta objek data kompleks lewat `extra`. |
| **Dukungan Web & Deep Linking** | Rumit, rentan terhadap kehilangan status saat pengguna me-refresh browser. | Terintegrasi langsung dengan browser history, sinkronisasi URL otomatis, dan ramah *deep linking*. |
| **Pengelolaan Back Button** | Sederhana tetapi mudah rusak jika halaman dibuka langsung tanpa riwayat tumpukan. | Terstruktur dan mendukung navigasi fallback yang terprediksi (`context.go` / `Navigator.pop`). |

### 2. Manfaat Pemisahan Kode Menjadi Widget Terpisah (Modularisasi)
- **Keterbacaan dan Kemudahan Perawatan (*Maintainability*):** Pemisahan komponen ke dalam berkas-berkas independen seperti `ItemCardWidget`, `ProductImageWidget`, dan `FooterWidget` mencegah terjadinya *spaghetti code* serta berkas raksasa (*god file*).
- **Penggunaan Ulang Komponen (*Reusability*):** Widget seperti `ProductImageWidget` dapat dimanfaatkan di kartu katalog maupun di halaman detail dengan konfigurasi properti yang fleksibel tanpa menulis ulang kode pemuatan gambar.
- **Kemudahan Pengujian (*Testability*):** Kode modular sangat mempermudah pengujian otomatis. Terbukti pada berkas pengujian `test/widget_test.dart`, komponen kartu produk, footer identitas, dan transisi `Hero` dapat diverifikasi fungsionalitasnya secara terisolasi dan menyeluruh.
- **Penerapan Prinsip Clean Code:** Mempermudah kolaborasi tim pengembang dalam skala proyek yang lebih besar karena setiap berkas memiliki satu tanggung jawab spesifik (*Single Responsibility Principle*).
