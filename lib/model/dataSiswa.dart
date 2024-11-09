import 'package:hive/hive.dart';

part 'dataSiswa.g.dart';

@HiveType(typeId: 0)
class DataSiswa extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nis;

  @HiveField(2)
  final String nama;

  @HiveField(3)
  final String tanggal_lahir;

  @HiveField(4)
  final String jenkel;

  @HiveField(5)
  final String alamat;

  @HiveField(6)
  HiveList<DataKota> kota;

  DataSiswa({
    required this.id,
    required this.nis,
    required this.nama,
    required this.tanggal_lahir,
    required this.jenkel,
    required this.alamat,
    required this.kota,
  });
}

@HiveType(typeId: 1)
class DataKota extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nama;

  DataKota({
    required this.id,
    required this.nama,
  });
}
