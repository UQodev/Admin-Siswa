import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/pages/homePage.dart';
import 'package:data_siswa/pages/kotaPage.dart';
import 'package:data_siswa/pages/siswaPage.dart';
import 'package:data_siswa/widgets/appbar.dart';
import 'package:data_siswa/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataSiswaAdapter());
  Hive.registerAdapter(DataKotaAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Siswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xffd22f3c),
        hintColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          color: Color(0xffd22f3c),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffd22f3c),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Beranda'),
      drawer: const Drawer(
        width: 278,
        child: AppDrawer(),
      ),
      body: HomePage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xffd22f3c),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SiswaPage()),
                );
              },
              icon: const Icon(
                Icons.school,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KotaPage()),
                );
              },
              icon: const Icon(
                Icons.location_city,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
