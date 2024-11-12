import 'package:data_siswa/model/chartData.dart';
import 'package:data_siswa/model/dataSiswa.dart';
import 'package:data_siswa/pages/Kota/kotaPage.dart';
import 'package:data_siswa/pages/Siswa/siswaAddPage.dart';
import 'package:data_siswa/pages/Siswa/siswaPage.dart';
import 'package:data_siswa/widgets/appbar.dart';
import 'package:data_siswa/widgets/chart.dart';
import 'package:data_siswa/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DataSiswaAdapter());
  Hive.registerAdapter(DataKotaAdapter());

  await Hive.openBox<DataSiswa>('siswa');
  await Hive.openBox<DataKota>('kota');

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
              backgroundColor: const Color(0xfff94144),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      navigatorObservers: [MyNavigatorObserver()],
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPopNext(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute.settings.name == '/') {
      // Refresh data when returning to HomePage
      final homePageState = route.settings.arguments as _HomePageState?;
      homePageState?.refreshData();
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<DataSiswa> _siswaBox;
  late Box<DataKota> _kotaBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    _siswaBox = await Hive.openBox<DataSiswa>('datasiswas');
    _kotaBox = await Hive.openBox<DataKota>('datakotas');
    setState(() {
      _isLoading = false;
    });
  }

  void refreshData() {
    setState(() {
      _isLoading = true;
    });
    _openBoxes();
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalSiswa = _siswaBox.length;
    final totalLaki =
        _siswaBox.values.where((siswa) => siswa.jenkel == 'Laki-laki').length;
    final totalPerempuan =
        _siswaBox.values.where((siswa) => siswa.jenkel == 'Perempuan').length;

    final dataJenisKelamin = [
      ChartData('Laki-Laki', totalLaki),
      ChartData('Perempuan', totalPerempuan),
    ].where((data) => data.value > 0).toList();

    final dataKota = _kotaBox.values
        .map((kota) {
          final totalSiswaKota = _siswaBox.values
              .where((siswa) => siswa.kota.contains(kota))
              .length;
          return ChartData(kota.nama, totalSiswaKota);
        })
        .where((data) => data.value > 0)
        .toList();
    ;

    final dataTahunKelahiran = _siswaBox.values
        .fold<Map<String, int>>({}, (map, siswa) {
          final tahun = siswa.tanggal_lahir.split('-')[0]; // Extract year
          map[tahun] = (map[tahun] ?? 0) + 1;
          return map;
        })
        .entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Beranda'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GridView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            children: [
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 10, 16),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "$totalSiswa",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 176, 177),
                      ),
                    ),
                    const Text(
                      "Total Siswa",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 10, 16),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "$totalLaki",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 176, 177),
                      ),
                    ),
                    const Text(
                      "Laki-Laki",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 10, 16),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "$totalPerempuan",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 176, 177),
                      ),
                    ),
                    const Text(
                      "Perempuan",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GridView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            children: [
              GestureDetector(
                onTap: () {
                  _showDataDialog(context, 'Jenis Kelamin', dataJenisKelamin);
                },
                child: Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 198, 10, 16),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Siswa Per Jenis Kelamin",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        height: 145,
                        width: 145,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: DoughnutChart(data: dataJenisKelamin),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDataDialog(context, 'Kota', dataKota);
                },
                child: Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 198, 10, 16),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Siswa Per Asal Kota",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        height: 145,
                        width: 145,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: PieChart(data: dataKota),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _showDataDialog(context, 'Tahun Kelahiran', dataTahunKelahiran);
              },
              child: GridView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 198, 10, 16),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Jumlah Siswa berdasarkan Tahun Kelahiran",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xffffffff),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 350,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: BarChart(data: dataTahunKelahiran),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffd22f3c),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SiswaAddPage()),
          );
          if (result == true) {
            refreshData(); // Refresh data if signal received
          }
        },
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        shape: const CircularNotchedRectangle(),
        color: const Color(0xffd22f3c),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SiswaPage()),
                    );
                    if (result == true) {
                      refreshData(); // Refresh data if signal received
                    }
                  },
                  icon: const Icon(
                    Icons.school,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Siswa',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KotaPage()),
                    );
                  },
                  icon: const Icon(
                    Icons.location_city,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Kota',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDataDialog(
      BuildContext context, String title, List<ChartData> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: data.map((data) {
              return ListTile(
                title: Text(data.label),
                trailing: Text(data.value.toString()),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
