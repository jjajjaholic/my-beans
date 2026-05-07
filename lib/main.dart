import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bean_detail_card.dart';
import 'bean_registration_screen.dart';
import 'brew_history_screen.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7), // iOS 스타일 배경색
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BrewHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: CupertinoColors.activeBlue,
        unselectedItemColor: CupertinoColors.systemGrey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            activeIcon: Icon(CupertinoIcons.cube_box_fill),
            label: '현재 재고',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time),
            activeIcon: Icon(CupertinoIcons.time_solid),
            label: '추출 기록',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '현재 재고', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue, size: 28),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BeanRegistrationScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          BeanDetailCard(
            imagePath: 'assets/koffee_sniffer.png',
            name: "Colombia Campo Hermoso Sudan Rume Washed C.M",
            roaster: "Koffee Sniffer",
            roastDate: DateTime(2026, 3, 5),
            currentWeight: 200,
            initialWeight: 200,
            flavorNotes: "Cilantro, Peppermint, Papaya, Cotton Candy, Floral",
            purchaseUrl: "https://koffeesniffer.kr/",
          ),
        ],
      ),
    );
  }
}
