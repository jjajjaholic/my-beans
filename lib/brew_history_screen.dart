import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'brew_registration_screen.dart';

class BrewHistoryScreen extends StatelessWidget {
  const BrewHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
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
              '추출 기록', 
              style: TextStyle(
                color: Color(0xFF1C150E), 
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
                  builder: (context) => const BrewRegistrationScreen(),
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
          _buildBrewLogCard(
            context: context,
            date: DateTime.now().subtract(const Duration(hours: 2)),
            beanName: 'Colombia Campo Hermoso Sudan Rume Washed C.M',
            method: '핸드드립 (V60)',
            dose: 20,
            yieldAmount: 300,
            rating: 4.5,
          ),
          _buildBrewLogCard(
            context: context,
            date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
            beanName: 'Colombia Campo Hermoso Sudan Rume Washed C.M',
            method: '에스프레소',
            dose: 18,
            yieldAmount: 36,
            rating: 5.0,
          ),
          _buildBrewLogCard(
            context: context,
            date: DateTime.now().subtract(const Duration(days: 2)),
            beanName: 'Colombia Campo Hermoso Sudan Rume Washed C.M',
            method: '에어로프레스',
            dose: 15,
            yieldAmount: 200,
            rating: 3.5,
          ),
        ],
      ),
    );
  }

  Widget _buildBrewLogCard({
    required BuildContext context,
    required DateTime date,
    required String beanName,
    required String method,
    required double dose,
    required double yieldAmount,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy.MM.dd HH:mm').format(date),
                style: const TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/coffee_cup_icon.png', width: 28, height: 28),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            beanName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6B46).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              method,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B6B46),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE5E5EA)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('사용량(Dose)', '${dose.toStringAsFixed(0)}g'),
              _buildStatItem('추출량(Yield)', '${yieldAmount.toStringAsFixed(0)}g'),
              _buildStatItem('비율(Ratio)', '1:${(yieldAmount / dose).toStringAsFixed(1)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
