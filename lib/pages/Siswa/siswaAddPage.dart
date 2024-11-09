import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/repository/dataSiswa.dart';
import 'package:data_siswa/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class SiswaAddPage extends StatefulWidget {
  final DataSiswa? dataSiswa;
  const SiswaAddPage({super.key, this.dataSiswa});

  @override
  _SiswaAddPageState createState() => _SiswaAddPageState();
}

class _SiswaAddPageState extends State<SiswaAddPage> {
  final _formKey = GlobalKey<FormState>();
  final DataSiswaRepository repository = DataSiswaRepository();

  late TextEditingController _nisController;
  late TextEditingController _namaController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  List<DataKota> _selectedKota = [];
  String? jenkel;

  @override
  void initState() {
    super.initState();
    _nisController = TextEditingController(text: widget.dataSiswa?.nis ?? '');
    _namaController = TextEditingController(text: widget.dataSiswa?.nama ?? '');
    _tanggalLahirController =
        TextEditingController(text: widget.dataSiswa?.tanggal_lahir ?? '');
    _alamatController =
        TextEditingController(text: widget.dataSiswa?.alamat ?? '');
    _selectedKota = widget.dataSiswa?.kota.toList() ?? [];
    jenkel = widget.dataSiswa?.jenkel;
  }

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _saveSiswa() async {
    if (_formKey.currentState?.validate() ?? false) {
      final siswa = DataSiswa(
        id: widget.dataSiswa?.id ?? UniqueKey().toString(),
        nis: _nisController.text,
        nama: _namaController.text,
        tanggal_lahir: _tanggalLahirController.text,
        jenkel: jenkel ?? '',
        alamat: _alamatController.text,
        kota: HiveList(await repository.getBoxKota())..addAll(_selectedKota),
      );

      if (widget.dataSiswa != null) {
        await repository.updateDataSiswa(siswa);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Siswa berhasil diubah'),
          ),
        );
      } else {
        await repository.addDataSiswa(siswa);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Siswa berhasil ditambahkan'),
          ),
        );
      }

      Navigator.of(context).pop(true);
    }
  }

  Future<void> _selectTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // Format the date to dd-MM-yyyy
        _tanggalLahirController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tambah Data Siswa',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nisController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIS',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silahkan isi NIS terlebih dahulu!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silahkan isi Nama terlebih dahulu!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTanggalLahir(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _tanggalLahirController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan isi Tanggal Lahir terlebih dahulu!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Jenis Kelamin'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: 'Laki-laki',
                      groupValue: jenkel,
                      onChanged: (String? value) {
                        setState(() {
                          jenkel = value;
                        });
                      },
                    ),
                    const Text('Laki-Laki'),
                    Radio<String>(
                      value: 'Perempuan',
                      groupValue: jenkel,
                      onChanged: (String? value) {
                        setState(() {
                          jenkel = value;
                        });
                      },
                    ),
                    const Text('Perempuan'),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _alamatController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silahkan isi Alamat terlebih dahulu!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<DataKota>>(
                  future: repository.getDataKota(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final kotaList = snapshot.data!;
                    return DropdownButtonFormField<DataKota>(
                      value:
                          _selectedKota.isNotEmpty ? _selectedKota.first : null,
                      items: kotaList.map((kota) {
                        return DropdownMenuItem<DataKota>(
                          value: kota,
                          child: Text(kota.nama),
                        );
                      }).toList(),
                      onChanged: (kota) {
                        setState(() {
                          _selectedKota = kota != null ? [kota] : [];
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kota',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Silahkan pilih Kota terlebih dahulu!';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveSiswa,
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
