import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/repository/dataSiswa.dart';
import 'package:flutter/material.dart';

class KotaAddPage extends StatefulWidget {
  DataKota? dataKota;
  KotaAddPage({super.key, this.dataKota});

  @override
  _KotaAddPageState createState() => _KotaAddPageState();
}

class _KotaAddPageState extends State<KotaAddPage> {
  DataSiswaRepository repository = DataSiswaRepository();
  TextEditingController kotaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.dataKota != null) {
      kotaController.text = widget.dataKota!.nama;
    }
  }

  void saveKota() {
    if (_formKey.currentState?.validate() ?? false) {
      final kota = kotaController.text;
      if (kota.isNotEmpty) {
        final dataKota = DataKota(
          id: widget.dataKota?.id ?? UniqueKey().toString(),
          nama: kota,
        );
        if (widget.dataKota != null) {
          repository.updateDataKota(dataKota);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kota berhasil diubah'),
            ),
          );
        } else {
          repository.addDataKota(dataKota);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kota berhasil ditambahkan'),
            ),
          );
        }
        setState(() {});
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Data Kota',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: kotaController,
                  decoration: const InputDecoration(
                      labelText: 'Kota',
                      hintText: 'Masukkan nama kota',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silahkan isi Kota terlebih dahulu!';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: saveKota,
                      child: const Text('Simpan'),
                    ),
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
