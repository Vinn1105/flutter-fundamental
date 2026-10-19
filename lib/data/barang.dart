import 'package:pml/domain/barang.dart';

/// Daftar dummy data produk barang untuk katalog belanja marketplace.
/// Setiap produk memiliki atribut id, nama, harga, foto, stok, dan rating.
final List<Barang> listBarang = [
  const Barang(
    id: 1,
    nama: 'Mentimun Organik Segar',
    harga: 8500,
    foto: 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=600&auto=format&fit=crop&q=80',
    stok: 35,
    rating: 4.8,
  ),
  const Barang(
    id: 2,
    nama: 'Tomat Ceri Merah Segar',
    harga: 12000,
    foto: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    stok: 24,
    rating: 4.9,
  ),
  const Barang(
    id: 3,
    nama: 'Cabai Rawit Merah Super',
    harga: 25000,
    foto: 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600&auto=format&fit=crop&q=80',
    stok: 15,
    rating: 4.7,
  ),
  const Barang(
    id: 4,
    nama: 'Wortel Impor Manis',
    harga: 14500,
    foto: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5c317?w=600&auto=format&fit=crop&q=80',
    stok: 40,
    rating: 4.6,
  ),
  const Barang(
    id: 5,
    nama: 'Brokoli Hijau Segar',
    harga: 18000,
    foto: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=600&auto=format&fit=crop&q=80',
    stok: 18,
    rating: 4.9,
  ),
  const Barang(
    id: 6,
    nama: 'Apel Fuji Manis Renyah',
    harga: 32000,
    foto: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
    stok: 20,
    rating: 4.8,
  ),
  const Barang(
    id: 7,
    nama: 'Pisang Cavendish Premium',
    harga: 22500,
    foto: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=600&auto=format&fit=crop&q=80',
    stok: 30,
    rating: 4.7,
  ),
  const Barang(
    id: 8,
    nama: 'Kentang Dieng Super',
    harga: 16000,
    foto: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=600&auto=format&fit=crop&q=80',
    stok: 50,
    rating: 4.5,
  ),
];

/// Alias list_barang untuk menjaga kompatibilitas dengan kode yang sudah ada
// ignore: non_constant_identifier_names
final List<Barang> list_barang = listBarang;