// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataSiswa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataSiswaAdapter extends TypeAdapter<DataSiswa> {
  @override
  final int typeId = 0;

  @override
  DataSiswa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataSiswa(
      id: fields[0] as String,
      nis: fields[1] as String,
      nama: fields[2] as String,
      tanggal_lahir: fields[3] as String,
      jenkel: fields[4] as String,
      alamat: fields[5] as String,
      kota: (fields[6] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, DataSiswa obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nis)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.tanggal_lahir)
      ..writeByte(4)
      ..write(obj.jenkel)
      ..writeByte(5)
      ..write(obj.alamat)
      ..writeByte(6)
      ..write(obj.kota);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSiswaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataKotaAdapter extends TypeAdapter<DataKota> {
  @override
  final int typeId = 1;

  @override
  DataKota read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataKota(
      id: fields[0] as String,
      nama: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DataKota obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataKotaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
