import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/pages/Kota/kotaAddPage.dart';
import 'package:data_siswa/repository/dataSiswa.dart';
import 'package:data_siswa/widgets/appbar.dart';
import 'package:flutter/material.dart';

class KotaPage extends StatefulWidget {
  KotaPage({Key? key}) : super(key: key);

  @override
  _KotaPageState createState() => _KotaPageState();
}

class _KotaPageState extends State<KotaPage> {
  DataSiswaRepository _repository = DataSiswaRepository();
  List<DataKota> _dataKota = [];

  @override
  void initState() {
    super.initState();
    _loadKotaList();
  }

  Future<void> _loadKotaList() async {
    final dataKota = await _repository.getDataKota();
    setState(() {
      _dataKota = dataKota;
    });
  }

  Future<void> _deleteKota(DataKota datakota) async {
    // Confirm delete action
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

    // If the user confirmed, delete the todo
    if (shouldDelete == true) {
      await _repository.deleteDataKota(datakota.id); // Perform deletion
      _loadKotaList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Data Kota',
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
              builder: (context) => KotaAddPage(),
            ),
          )
              .then((value) {
            if (value != null) {
              _loadKotaList();
            }
          });
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
      body: _dataKota.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada data Kota",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ListView.builder(
                itemCount: _dataKota.length,
                itemBuilder: (context, index) {
                  final datakota = _dataKota[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        datakota.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KotaAddPage(
                                      dataKota:
                                          datakota), // Pass the todo to the edit page
                                ),
                              ).then((_) {
                                // Reload todos after returning from InputTodoPage
                                _loadKotaList();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteKota(datakota);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
