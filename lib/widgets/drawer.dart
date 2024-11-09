import 'package:data_siswa/main.dart';
import 'package:data_siswa/pages/Kota/kotaPage.dart';
import 'package:data_siswa/pages/Siswa/siswaPage.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Ganti dengan warna yang Anda inginkan
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Text(
                    'Data Siswa',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6d0205)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(
                    color: Color(0xffc6c6c6),
                    height: 16,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.home,
                          color: Color(0xffd22f3c),
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Beranda',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff6d0205),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SiswaPage()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.school, color: Color(0xffd22f3c), size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Siswa',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff6d0205),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KotaPage()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.location_city_rounded,
                            size: 30, color: Color(0xffd22f3c)),
                        SizedBox(width: 10),
                        Text(
                          'Kota',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff6d0205),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tambahkan item drawer lainnya di sini
              ],
            ),
          ),
        ),
      ),
    );
  }
}
