import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bean_detail_card.dart';
import 'bean_registration_screen.dart';
import 'brew_history_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF9F6F0), // 따뜻한 커피 베이지색
        textTheme: GoogleFonts.juaTextTheme(),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.jua(
            color: const Color(0xFF1C150E),
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ),
      builder: (context, child) {
        return Container(
          color: const Color(0xFFE5E5EA), // 넓은 화면일 때 좌우 여백의 배경색 (부드러운 회색)
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: child,
          ),
        );
      },
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
        selectedItemColor: const Color(0xFF8B6B46), // Espresso Brown
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
        toolbarHeight: 70,
        title: Row(
          children: [
            Image.asset(
              'assets/character_new.png', 
              width: 65, 
              height: 65, 
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'My Beans', 
              style: TextStyle(
                color: Color(0xFF1C150E), // Black Coffee
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: -0.5,
              )
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: Color(0xFF8B6B46), size: 28),
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
