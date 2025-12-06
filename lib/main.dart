import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/health_records/provider/health_record_provider.dart';
import 'features/health_records/ui/dashboard_screen.dart';
import 'features/health_records/ui/add_record_screen.dart';
import 'features/health_records/ui/health_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = HealthRecordProvider();
  await provider.loadRecords(); 

  runApp(HealthMateApp(provider: provider));
}

class HealthMateApp extends StatelessWidget {
  final HealthRecordProvider provider;

  const HealthMateApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealthMate',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final screens = const [
    DashboardScreen(),
    AddRecordScreen(),
    HealthListScreen(),
  ];

  final titles = const [
    "HealthMate",
    "Add Record",
    "Health Records",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepOrange.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.dashboard, color: Colors.deepOrange),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.add_circle, color: Colors.deepOrange),
            label: "Add",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.list_alt, color: Colors.deepOrange),
            label: "Records",
          ),
        ],
      ),
    );
  }
}
