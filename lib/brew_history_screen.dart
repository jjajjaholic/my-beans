import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'brew_registration_screen.dart';

class BrewHistoryScreen extends StatelessWidget {
  const BrewHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          '추출 기록', 
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
            date: DateTime.now().subtract(const Duration(hours: 2)),
            beanName: '에티오피아 예가체프 아리차 G1',
            method: '핸드드립 (V60)',
            dose: 20,
            yieldAmount: 300,
            rating: 4.5,
          ),
          _buildBrewLogCard(
            date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
            beanName: '콜롬비아 엘 파라이소 리치',
            method: '에스프레소',
            dose: 18,
            yieldAmount: 36,
            rating: 5.0,
          ),
          _buildBrewLogCard(
            date: DateTime.now().subtract(const Duration(days: 2)),
            beanName: '과테말라 안티구아',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 14),
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
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              method,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.activeBlue,
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
            color: Colors.grey,
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
