import 'package:data_siswa/model/dataSiswa.dart';
import 'package:hive_flutter/adapters.dart';

class DataSiswaRepository {
  static const String _boxNameSiswa = 'datasiswas';
  static const String _boxNameKota = 'datakotas';

  Future<Box<DataSiswa>> getBoxSiswa() async {
    return await Hive.openBox<DataSiswa>(_boxNameSiswa);
  }

  Future<Box<DataKota>> getBoxKota() async {
    return await Hive.openBox<DataKota>(_boxNameKota);
  }

  /* Siswa Repository */
  // Create
  Future<void> addDataSiswa(DataSiswa dataSiswa) async {
    var boxSiswa = await getBoxSiswa();
    var boxKota = await getBoxKota();

    dataSiswa.kota = HiveList(boxKota);
    dataSiswa.kota.addAll(dataSiswa.kota);

    await boxSiswa.put(dataSiswa.id, dataSiswa);
  }

  // Get
  Future<DataSiswa?> getDataSiswa(String id) async {
    var boxSiswa = await getBoxSiswa();
    return boxSiswa.get(id);
  }

  // Put / Update
  Future<void> updateDataSiswa(DataSiswa dataSiswa) async {
    var boxSiswa = await getBoxSiswa();
    await boxSiswa.put(dataSiswa.id, dataSiswa);
  }

  // Delete
  Future<void> deleteDataSiswa(String id) async {
    var boxSiswa = await getBoxSiswa();
    await boxSiswa.delete(id);
  }

  /* Kota Repository */
  // Create
  Future<void> addDataKota(DataKota dataKota) async {
    var boxKota = await getBoxKota();
    await boxKota.put(dataKota.id, dataKota);
  }

  // Get / Read
  Future<List<DataKota>> getDataKota() async {
    var boxKota = await getBoxKota();
    return boxKota.values.toList();
  }

  // Put / Update
  Future<void> updateDataKota(DataKota dataKota) async {
    var boxKota = await getBoxKota();
    await boxKota.put(dataKota.id, dataKota);
  }

  // Delete
  Future<void> deleteDataKota(String id) async {
    var boxKota = await getBoxKota();
    await boxKota.delete(id);
  }
}
