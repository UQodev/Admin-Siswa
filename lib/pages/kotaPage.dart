import 'package:flutter/material.dart';

class KotaPage extends StatefulWidget {
  const KotaPage({super.key});

  @override
  State<KotaPage> createState() => _KotaPageState();
}

class _KotaPageState extends State<KotaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Kota',
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
        child: Text('Kota Page'),
      ),
    );
  }
}
