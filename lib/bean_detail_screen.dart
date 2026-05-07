import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BeanDetailScreen extends StatelessWidget {
  final String name;
  final String roaster;
  final DateTime roastDate;
  final double currentWeight;
  final double initialWeight;
  final String flavorNotes;
  final String? imagePath;
  final String? purchaseUrl;

  const BeanDetailScreen({
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

  Future<void> _launchUrl(BuildContext context) async {
    if (purchaseUrl == null || purchaseUrl!.isEmpty) return;
    final Uri url = Uri.parse(purchaseUrl!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('오류'),
            content: const Text('구매처 링크를 열 수 없습니다.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text(
          '원두 상세 정보',
          style: TextStyle(
            color: Color(0xFF1C150E),
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Color(0xFF1C150E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null && imagePath!.isNotEmpty && imagePath != 'dummy_image_path')
              SizedBox(
                width: double.infinity,
                height: 350,
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 350,
                color: CupertinoColors.systemGrey5,
                child: const Icon(CupertinoIcons.photo_camera_solid, color: CupertinoColors.systemGrey2, size: 64),
              ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roaster.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('로스팅 날짜', DateFormat('yyyy.MM.dd').format(roastDate)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFE5E5EA)),
                        ),
                        _buildDetailRow('남은 용량', '${currentWeight.toStringAsFixed(0)}g / ${initialWeight.toStringAsFixed(0)}g'),
                      ],
                    ),
                  ),
                  
                  if (flavorNotes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Tasting Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flavorNotes,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 40),
                  
                  if (purchaseUrl != null && purchaseUrl!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: CupertinoButton(
                        color: const Color(0xFF8B6B46), // Espresso Brown
                        borderRadius: BorderRadius.circular(16),
                        child: const Text(
                          '구매처로 이동',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _launchUrl(context),
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
