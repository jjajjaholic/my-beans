import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bean_detail_screen.dart';

class BeanDetailCard extends StatelessWidget {
  final String name;
  final String roaster;
  final DateTime roastDate;
  final double currentWeight;
  final double initialWeight;
  final String flavorNotes;
  final String? imagePath;
  final String? purchaseUrl;

  const BeanDetailCard({
    Key? key,
    required this.name,
    required this.roaster,
    required this.roastDate,
    required this.currentWeight,
    required this.initialWeight,
    required this.flavorNotes,
    this.imagePath,
    this.purchaseUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 로스팅 이후 경과 일수 계산
    final daysSinceRoast = DateTime.now().difference(roastDate).inDays;
    
    // 신선도 상태 및 게이지 값 계산
    double freshnessValue = 0.0;
    String freshnessStatus = "알 수 없음";
    Color freshnessColor = CupertinoColors.systemGrey;

    if (daysSinceRoast < 0) {
      freshnessStatus = "로스팅 전";
      freshnessValue = 0.0;
    } else if (daysSinceRoast <= 3) {
      freshnessStatus = "디개싱 (Resting)";
      freshnessValue = daysSinceRoast / 3 * 0.25; 
      freshnessColor = CupertinoColors.systemTeal;
    } else if (daysSinceRoast <= 14) {
      freshnessStatus = "최상의 맛 (Peak)";
      freshnessValue = 0.25 + ((daysSinceRoast - 3) / 11 * 0.5); 
      freshnessColor = CupertinoColors.systemGreen;
    } else if (daysSinceRoast <= 30) {
      freshnessStatus = "양호 (Good)";
      freshnessValue = 0.75 + ((daysSinceRoast - 14) / 16 * 0.25);
      freshnessColor = CupertinoColors.systemYellow;
    } else {
      freshnessStatus = "풍미 저하 (Past Peak)";
      freshnessValue = 1.0;
      freshnessColor = CupertinoColors.systemRed;
    }

    // 재고 게이지 계산
    double stockValue = currentWeight / initialWeight;
    if (stockValue < 0) stockValue = 0;
    if (stockValue > 1) stockValue = 1;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BeanDetailScreen(
              name: name,
              roaster: roaster,
              roastDate: roastDate,
              currentWeight: currentWeight,
              initialWeight: initialWeight,
              flavorNotes: flavorNotes,
              imagePath: imagePath,
              purchaseUrl: purchaseUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(20), // iOS 스타일의 부드러운 둥근 모서리
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
          // 헤더: 로스터리와 이름, 그리고 남은 용량 배지
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: CupertinoColors.systemGrey5,
                    child: imagePath == 'dummy_image_path' || imagePath!.isEmpty
                        ? const Icon(CupertinoIcons.photo_camera_solid, color: CupertinoColors.systemGrey2, size: 28)
                        : Image.asset(imagePath!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roaster.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (flavorNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              flavorNotes,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                height: 1.4,
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // 신선도 게이지 섹션
          _buildGaugeSection(
            title: '신선도',
            valueLabel: freshnessStatus,
            dateLabel: '로스팅: ${DateFormat('yyyy.MM.dd').format(roastDate)} (+$daysSinceRoast일)',
            gaugeValue: freshnessValue,
            gaugeColor: freshnessColor,
          ),
          
          const SizedBox(height: 16),
          
          // 재고량 게이지 섹션
          _buildGaugeSection(
            title: '재고량',
            valueLabel: '${(stockValue * 100).toInt()}%',
            dateLabel: '${currentWeight.toStringAsFixed(0)}g / ${initialWeight.toStringAsFixed(0)}g',
            gaugeValue: stockValue,
            gaugeColor: stockValue > 0.2 ? const Color(0xFF8B6B46) : CupertinoColors.systemRed,
          ),
        ],
      ),
    ));
  }

  Widget _buildGaugeSection({
    required String title,
    required String valueLabel,
    required String dateLabel,
    required double gaugeValue,
    required Color gaugeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              valueLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: gaugeColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 커스텀 게이지 바 (iOS 스타일로 둥글고 얇게)
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: gaugeValue,
              backgroundColor: CupertinoColors.tertiarySystemGroupedBackground,
              valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dateLabel,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
