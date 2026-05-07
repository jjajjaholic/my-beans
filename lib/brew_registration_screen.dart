import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrewRegistrationScreen extends StatefulWidget {
  const BrewRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<BrewRegistrationScreen> createState() => _BrewRegistrationScreenState();
}

class _BrewRegistrationScreenState extends State<BrewRegistrationScreen> {
  final List<String> _myBeans = [
    'Colombia Campo Hermoso Sudan Rume Washed C.M'
  ];
  String? _selectedBean;
  
  final _doseController = TextEditingController();
  final _yieldController = TextEditingController();
  final _memoController = TextEditingController();
  
  String _selectedMethod = '핸드드립';
  double _rating = 3.0;

  @override
  void dispose() {
    _doseController.dispose();
    _yieldController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _showBeanPicker() {
    int initialIndex = _selectedBean == null ? 0 : _myBeans.indexOf(_selectedBean!);
    if (initialIndex == -1) initialIndex = 0;
    
    if (_selectedBean == null && _myBeans.isNotEmpty) {
      setState(() { _selectedBean = _myBeans[initialIndex]; });
    }

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedBean = _myBeans[index];
                  });
                },
                children: _myBeans.map((bean) => Center(child: Text(bean, style: const TextStyle(fontSize: 18)))).toList(),
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
          '새 추출 기록',
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
              // TODO: 데이터베이스에 추출 기록 저장 로직 구현 예정
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
          _buildSectionTitle('어떤 원두를 내리셨나요?'),
          _buildInputCard([
            _buildBeanSelectorRow(),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionTitle('추출 도구'),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: _selectedMethod,
              children: const {
                '핸드드립': Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('핸드드립')),
                '에스프레소': Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('에스프레소')),
                '기타': Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('기타')),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMethod = value;
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('레시피 (선택)'),
          _buildInputCard([
            _buildTextField('사용량 (Dose, g)', _doseController, isNumber: true),
            const Divider(height: 1, color: Color(0xFFE5E5EA)),
            _buildTextField('추출량 (Yield, g)', _yieldController, isNumber: true),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle('맛에 대한 평가'),
          _buildInputCard([
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? CupertinoIcons.star_fill : CupertinoIcons.star,
                      color: CupertinoColors.systemYellow,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E5EA)),
            _buildTextField('맛은 어땠나요? 메모를 남겨보세요.', _memoController, maxLines: 3),
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

  Widget _buildBeanSelectorRow() {
    return InkWell(
      onTap: _showBeanPicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('선택된 원두', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedBean ?? '원두를 선택하세요',
                style: TextStyle(
                  fontSize: 16, 
                  color: _selectedBean == null ? Colors.black26 : CupertinoColors.activeBlue,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
}
