import 'package:flutter/material.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Siswa',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffd22f3c),
        onPressed: () {},
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
      body: const Center(
        child: Text('Siswa Page'),
      ),
    );
  }
}
