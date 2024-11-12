import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/pages/Siswa/siswaAddPage.dart';
import 'package:data_siswa/repository/dataSiswa.dart';
import 'package:data_siswa/widgets/appbar.dart';
import 'package:flutter/material.dart';

class SiswaPage extends StatefulWidget {
  final DataSiswa? dataSiswa;
  const SiswaPage({super.key, this.dataSiswa});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  final DataSiswaRepository _repository = DataSiswaRepository();
  List<DataSiswa> _dataSiswa = [];

  @override
  void initState() {
    super.initState();
    _loadSiswaList();
  }

  Future<void> _loadSiswaList() async {
    // Open the box for datakotas first
    await _repository.getBoxKota();
    final boxSiswa = await _repository.getBoxSiswa();
    setState(() {
      _dataSiswa = boxSiswa.values.toList();
    });

    for (var siswa in _dataSiswa) {
      print(
          'Loaded Siswa: ${siswa.nama}, Kota: ${siswa.kota.map((k) => k.nama).join(', ')}');
    }
  }

  Future<void> _deleteSiswa(DataSiswa siswa) async {
    final bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _repository.deleteDataSiswa(siswa.id); // Perform deletion
      _loadSiswaList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus.')),
      );
      Navigator.pop(context, true); // Send signal to HomePage to refresh data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Data Siswa',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffd22f3c),
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => SiswaAddPage(),
            ),
          )
              .then((value) {
            if (value != null) {
              _loadSiswaList();
            }
          });
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _dataSiswa.length,
                itemBuilder: (context, index) {
                  final dataSiswa = _dataSiswa[index];
                  final dataKota =
                      dataSiswa.kota.map((kota) => kota.nama).join(', ');
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(dataSiswa.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NIS: ${dataSiswa.nis}'),
                          Text('Tanggal Lahir: ${dataSiswa.tanggal_lahir}'),
                          Text('Jenis Kelamin: ${dataSiswa.jenkel}'),
                          Text('Alamat: ${dataSiswa.alamat}'),
                          Text('Kota: $dataKota'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.orange,
                            ),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SiswaAddPage(dataSiswa: dataSiswa),
                                ),
                              );
                              if (result == true) {
                                // Reload siswa list after returning from edit page
                                _loadSiswaList();
                                // Send signal to HomePage to refresh data
                                Navigator.pop(context, true);
                              }
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteSiswa(dataSiswa);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
