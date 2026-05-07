import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeanRegistrationScreen extends StatefulWidget {
  const BeanRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<BeanRegistrationScreen> createState() => _BeanRegistrationScreenState();
}

class _BeanRegistrationScreenState extends State<BeanRegistrationScreen> {
  final _nameController = TextEditingController();
  final _roasterController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _roastDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _roasterController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: CupertinoDatePicker(
                initialDateTime: _roastDate,
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (val) {
                  setState(() {
                    _roastDate = val;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          '새 원두 등록',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 데이터베이스에 원두 저장하는 로직 구현 예정
              Navigator.of(context).pop();
            },
            child: const Text(
              '저장',
              style: TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                // TODO: 사진 촬영 또는 앨범 선택 로직
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.camera_fill, color: CupertinoColors.systemGrey, size: 32),
                    SizedBox(height: 8),
                    Text('사진 등록', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('기본 정보'),
          _buildInputCard([
            _buildTextField('원두 이름 (예: 예가체프 아리차)', _nameController),
            const Divider(height: 1, color: Color(0xFFE5E5EA)),
            _buildTextField('로스터리 (예: 나무사이로)', _roasterController),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle('상세 정보'),
          _buildInputCard([
            _buildDatePickerRow(),
            const Divider(height: 1, color: Color(0xFFE5E5EA)),
            _buildTextField('구매량(g) (예: 200)', _weightController, isNumber: true),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle('테이스팅 노트'),
          _buildInputCard([
            _buildTextField('플로럴, 복숭아, 꿀 등', _notesController, maxLines: 3),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInputCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
        ),
      ),
    );
  }

  Widget _buildDatePickerRow() {
    return InkWell(
      onTap: _showDatePicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('로스팅 날짜', style: TextStyle(fontSize: 16)),
            Text(
              '${_roastDate.year}.${_roastDate.month.toString().padLeft(2, '0')}.${_roastDate.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16, color: CupertinoColors.activeBlue),
            ),
          ],
        ),
      ),
    );
  }
}
