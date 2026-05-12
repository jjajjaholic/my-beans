import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'services/gemini_service.dart';

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

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isExtractingInfo = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
          _isExtractingInfo = true;
        });

        // Gemini API로 텍스트 추출 시도
        final bytes = await pickedFile.readAsBytes();
        final mimeType = lookupMimeType(pickedFile.path) ?? 'image/jpeg';
        
        final extractedData = await GeminiService.extractBeanInfo(bytes, mimeType);
        
        if (extractedData != null && mounted) {
          setState(() {
            if (extractedData['name'] != null) _nameController.text = extractedData['name'].toString();
            if (extractedData['roaster'] != null) _roasterController.text = extractedData['roaster'].toString();
            if (extractedData['weight'] != null) _weightController.text = extractedData['weight'].toString();
            if (extractedData['flavorNotes'] != null) _notesController.text = extractedData['flavorNotes'].toString();
            if (extractedData['roastDate'] != null) {
              try {
                _roastDate = DateTime.parse(extractedData['roastDate'].toString());
              } catch (e) {
                // Parse error ignore
              }
            }
            _isExtractingInfo = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사진에서 원두 정보를 성공적으로 추출했습니다!')),
          );
        } else {
          setState(() {
            _isExtractingInfo = false;
          });
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('정보 추출 실패: API Key가 없거나 사진을 인식할 수 없습니다.')),
             );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      setState(() {
        _isExtractingInfo = false;
      });
    }
  }

  void _handleImageSelection() {
    if (kIsWeb) {
      // 웹에서는 모달 없이 바로 갤러리(파일 탐색기) 팝업 실행
      _pickImage(ImageSource.gallery);
    } else {
      // 모바일에서는 모달 팝업으로 카메라/앨범 선택
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('사진 등록'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text('카메라로 촬영'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text('앨범에서 선택'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
        ),
      );
    }
  }

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
      backgroundColor: const Color(0xFFF9F6F0),
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
                color: Color(0xFF8B6B46),
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
              onTap: _handleImageSelection,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_selectedImage != null)
                      (kIsWeb
                          ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                          : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                    else
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera_fill, color: CupertinoColors.systemGrey, size: 32),
                          SizedBox(height: 8),
                          Text('사진 등록', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    if (_isExtractingInfo)
                      Container(
                        color: Colors.black45,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
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
